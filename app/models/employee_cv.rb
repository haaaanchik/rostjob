class EmployeeCv < ApplicationRecord
  include AASM

  has_many :proposal_employees
  has_many :orders, through: :proposal_employees

  belongs_to :proposal, optional: true
  belongs_to :order, optional: true
  belongs_to :profile, optional: true

  scope :proposed, -> {where(state: %w[hired applyed])}
  scope :available, ->(profile_id) {where(state: %w[ready applyed], profile_id: profile_id)}
  scope :available_free, ->(profile_id, proposal_id) {available(profile_id).where("proposal_id IS NULL")}

  validates :name, presence: true
  validate :ext_data_phone
  # validates :gender, presence: true
  # validates :birthdate, presence: true

  attr_accessor :mark_ready
  has_attached_file :file
  # validates_attachment_content_type :file,
  #                                   content_type: [%r{\Aapplication/pdf\z}, %r{\Aimage/.*}, %r{text/.*}]

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

    event :make_ready do
      transitions from: :draft, to: :ready
    end

    event :apply do
      transitions from: [:draft, :ready], to: :applyed
    end

    event :hire do
      transitions from: :applyed, to: :hired
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
    %i[pser pnum pdate pcode address phone phone_alt education experiense remark]
  end

  def state_rus
    self.class.possible_states[state.to_sym]
  end

  def self.possible_states
    {
      draft: 'Черновик',
      ready: 'Готов',
      applyed: 'Отправлена',
      hired: 'Нанят',
      archieved: 'Архивирован'
    }
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
                              marks: {viewed_by_cunsomer: false}
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
