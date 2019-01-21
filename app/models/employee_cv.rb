class EmployeeCv < ApplicationRecord
  include AASM

  has_many :proposal_employees
  has_many :orders, through: :proposal_employees

  belongs_to :proposal, optional: true
  belongs_to :order, optional: true
  belongs_to :profile, optional: true

  scope :proposed, -> { where(state: %w[hired applyed]) }
  scope :available, ->(profile_id) { where(state: %w[ready applyed], profile_id: profile_id) }
  scope :available_free, ->(profile_id, proposal_id) { available(profile_id).where("proposal_id IS NULL") }

  validates :name, presence: true
  validates :phone_number, presence: true, phone: true
  validates :contractor_terms_of_service, acceptance: true
  # validate :ext_data_phone
  # validates :gender, presence: true
  # validates :birthdate, presence: true

  attr_accessor :mark_ready
  has_attached_file :file
  # validates_attachment_content_type :file,
  #                                   content_type: [%r{\Aapplication/pdf\z}, %r{\Aimage/.*}, %r{text/.*}]
  has_attached_file :photo, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/img/no-avatar.jpg'
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  before_create :check_state
  before_save :check_marks

  aasm column: :state, skip_validation_on_save: true,
       no_direct_assignment: false do
    # черновик
    state :draft, initial: true
    state :ready
    # принята
    state :applyed
    # нанят
    state :hired
    # уволен (отказано)
    state :fired
    # ХЗ
    state :charged
    # Анкета в архиве
    state :archieved
    # Просмотрена
    state :viewed
    # Отклонена
    state :refused
    # Открыт спор
    state :disputed

    event :view do
      transitions from: :applyed, to: :viewed
    end

    event :refuse do
      transitions from: %i[applyed viewed], to: :refused
    end

    event :disput do
      transitions to: :disputed
    end

    event :archive do
      transitions to: :archieved
    end

    event :make_ready do
      transitions from: :draft, to: :ready
    end

    event :apply do
      transitions from: [:draft, :ready], to: :applyed
    end

    event :hire do
      transitions from: :applyed, to: :hired
      after do
        ps_s = proposal_employees.select {|d| d.proposal_id == proposal_id}
        ps_s.map(&:hire!)
        ps = proposal_employees.reject {|d| d.proposal_id == proposal_id}
        ps.map(&:destroy)
      end
    end

    event :unapply do
      transitions from: :applyed, to: :ready
    end

    event :fire do
      transitions from: :hired, to: :ready
    end

    event :charge do
      transitions from: :hired, to: :charged
    end
  end

  def self.ext_data_fields
    %i[pser pnum pdate pcode address phone_alt education experiense remark]
  end

  def self.possible_states
    aasm.states.map(&:name)
  end

  def with_mobile
    "#{name}; тел: #{phone}"
  end

  def phone
    vals = (ext_data || {})
    vals.fetch('phone', nil).to_s
  end

  def ext_data_phone
    return unless phone.empty?
    errors.add(:ext_data, 'Контактный телефон')
  end

  def check_marks
    return unless mark_ready
    self.state = :ready
  end

  def create_pr_empl(proposal_id)
    prp = Proposal.find_by id: proposal_id
    proposal_employees.create proposal_id: prp.id, order_id: prp.order_id,
                              profile_id: profile_id,
                              marks: {viewed_by_customer: false}
  end

  def rempve_pr_empl(proposal_id)
    empl = proposal_employees.where(proposal_id: proposal_id).first
    proposal_employees.destroy empl
  end

  def check_state
    return if proposal_id.blank?
    create_pr_empl(proposal_id)
    self.state = :applyed
    self.proposal_id = nil
  end
end
