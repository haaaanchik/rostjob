class EmployeeCv < ApplicationRecord
  include AASM

  belongs_to :proposal, optional: true
  belongs_to :order, optional: true
  belongs_to :profile, optional: true

  scope :proposed, -> {where(state: %w[hired applyed])}
  scope :available, ->(profile_id) {where(state: %w[draft applyed], profile_id: profile_id)}

  validates :name, presence: true
  validate :ext_data_phone
  # validates :gender, presence: true
  # validates :birthdate, presence: true

  has_attached_file :file
  # validates_attachment_content_type :file,
  #                                   content_type: [%r{\Aapplication/pdf\z}, %r{\Aimage/.*}, %r{text/.*}]

  before_create :check_state

  aasm column: :state, skip_validation_on_save: true,
       no_direct_assignment: false do
    # черновик
    state :draft, initial: true
    # принята
    state :applyed
    # нанят
    state :hired
    # уволен (отказано)
    state :fired
    # ХЗ
    state :charged

    event :apply do
      transitions from: :draft, to: :applyed
    end

    event :hire do
      transitions from: :applyed, to: :hired
    end

    event :fire do
      transitions from: :hired, to: :fired
    end

    event :charge do
      transitions from: :hired, to: :charged
    end
  end

  def self.ext_data_fields
    %i[pser pnum pdate pcode address phone phone_alt education experiense remark]
  end

  def state_rus
    {
      draft: 'Черновик',
      applyed: 'Предложен',
      hired: 'Нанят'
    }[state.to_sym]
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

  def check_state
    return if proposal_id.blank?
    self.state = :applyed
  end
end
