class ProposalEmployee < ApplicationRecord
  include AASM
  include ProposalEmployeeRepository

  delegate :to_close?, :to_open?, to: :order

  belongs_to :order
  belongs_to :profile
  belongs_to :employee_cv
  belongs_to :invoice, optional: true
  has_one :user, through: :profile
  has_many :complaints, dependent: :destroy
  has_many :incidents, dependent: :destroy
  has_one :user, through: :profile
  has_one :ticket

  validates :interview_date, :order_id, :employee_cv_id, presence: true
  validate :check_uniqueness_employee_cv

  accepts_nested_attributes_for :employee_cv

  ransack_alias :candidate_fields, :employee_cv_id_or_employee_cv_name_or_order_id_or_order_position_title_or_order_place_of_work
  ransack_alias :pe_fields, :employee_cv_id_or_employee_cv_name_or_order_id_or_order_position_title_or_order_place_of_work
  ransack_alias :order_title, :order_position_title
  ransack_alias :all_fields, :proposal_employee_or_employee_cv_name_or_order_id_or_order_profile_user_full_name

  aasm column: :state, whiny_transitions: false do
    state :inbox, initial: true
    state :interview
    state :hired
    state :disputed
    state :deleted
    state :viewed
    state :revoked
    state :rejected
    state :approved
    state :paid
    state :reserved
    state :transfer

    event :to_transfer do
      transitions to: :transfer
    end

    event :to_interview do
      transitions from: %i[inbox reserved disputed], to: :interview
    end

    event :to_inbox do
      transitions from: %i[transfer interview reserved disputed], to: :inbox
    end

    event :to_reserved do
      transitions from: %i[inbox interview disputed], to: :reserved
    end

    event :to_rejected do
      transitions from: :inbox, to: :rejected
    end

    event :to_approved do
      transitions from: :hired, to: :approved
    end

    event :to_paid, after: :set_payment_date do
      transitions from: :approved, to: :paid
    end

    event :to_revoked do
      transitions from: %i[inbox interview reserved disputed], to: :revoked
    end

    event :to_viewed do
      transitions from: :inbox, to: :viewed
    end

    event :to_disputed do
      transitions from: %i[inbox interview hired deleted approved], to: :disputed
    end

    event :to_deleted do
      transitions from: :inbox, to: :deleted
    end

    event :hire, after: :to_close? do
      transitions from: %i[interview viewed deleted disputed], to: :hired
    end
  end

  def initialize(attrs = nil)
    defaults = {
      interview_date: Date.today
    }

    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

  def set_payment_date
    self.update(payment_date: DateTime.current)
  end

  def mark_as_read
    update_attribute :marks, viewed_by_customer: true
  end

  def self.possible_states
    {
      inspected: 'На рассмотрении',
      applyed: 'Предложен',
      hired: 'Нанят',
      denied: 'Отказ'
    }
  end

  ransacker :order_id do
    Arel.sql("CONVERT(#{table_name}.order_id, CHAR(8))")
  end

  ransacker :employee_cv_id do
    Arel.sql("CONVERT(#{table_name}.employee_cv_id, CHAR(8))")
  end

  def mail_interview_customer
    ProposalEmployeeMailJob.perform_now(proposal_employees: [self], method: 'today_interview_customer') if order.profile.notify_mails?
  end

  private

  def check_uniqueness_employee_cv
    return if revoked?

    uniqueness = ProposalEmployee.joins(:employee_cv)
                     .where(order_id: order_id,
                            'employee_cvs.phone_number': employee_cv.phone_number)
                     .where.not(id: id,
                                state: 'revoked')

    errors.add(:employee_cv_id,
               'Такая анкета уже существует.') unless uniqueness.blank?
  end
end
