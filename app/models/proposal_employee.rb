class ProposalEmployee < ApplicationRecord
  include AASM

  belongs_to :order
  belongs_to :profile
  belongs_to :employee_cv
  has_many :complaints, dependent: :destroy
  has_many :incidents, dependent: :destroy

  validates :interview_date, :order_id, :employee_cv_id, presence: true

  accepts_nested_attributes_for :employee_cv

  ransack_alias :candidate_fields, :employee_cv_id_or_employee_cv_name_or_order_id_or_order_title_or_order_place_of_work
  ransack_alias :pe_fields, :employee_cv_id_or_employee_cv_name_or_order_id_or_order_title_or_order_place_of_work

  include ProposalEmployeeRepository

  aasm column: :state, whiny_transitions: false do
    state :inbox, initial: true
    state :interview
    state :hired
    state :disputed
    state :deleted
    state :viewed
    state :revoked
    state :rejected
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
      transitions from: :nbox, to: :rejected
    end

    event :to_paid, after: :set_payment_date do
      transitions from: :hired, to: :paid
    end

    event :to_revoked do
      transitions from: %i[inbox interview reserved disputed], to: :revoked
    end

    event :to_viewed do
      transitions from: :inbox, to: :viewed
    end

    event :to_disputed do
      transitions from: %i[inbox interview hired deleted], to: :disputed
    end

    event :to_deleted do
      transitions from: :inbox, to: :deleted
    end

    event :hire do
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
end
