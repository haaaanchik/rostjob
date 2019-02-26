class Order < ApplicationRecord
  include AASM
  extend Enumerize

  enumerize :urgency, in: %i[low middle high], scope: true, default: :middle

  belongs_to :profile
  has_many :invites
  has_many :candidates, class_name: 'ProposalEmployee'
  has_many :comments
  has_many :proposal_employees
  has_many :profiles, -> { distinct }, through: :proposal_employees
  has_many :order_profiles
  has_many :employee_cvs, through: :proposal_employees, source: :employee_cv

  validates :customer_price, :contractor_price, :customer_total, :contractor_total,
            presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :number_of_employees, presence: true, numericality: {only_integer: true}
  validates :title, :city, :experience, :description,
            :schedule, :work_period, presence: true
  validates :salary_from, presence: true, numericality: {only_integer: true}
  validates :salary_to, presence: true, numericality: {only_integer: true}
  # validates :commission, presence: true, numericality: { only_integer: true }
  # validates :payment_type, presence: true
  validates :warranty_period, presence: true, numericality: {only_integer: true}
  # validates :number_of_recruiters, presence: true, numericality: { only_integer: true }
  validates :accepted, acceptance: {message: 'must be abided'}

  include OrderRepository

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: false do
    state :draft, initial: true
    state :waiting_for_payment
    state :moderation
    state :published
    state :rejected
    state :hidden
    state :completed

    event :cancel do
      transitions from: %i[waiting_for_payment moderation rejected], to: :draft
    end

    event :wait_for_payment do
      transitions from: :draft, to: :waiting_for_payment
    end

    event :moderate do
      transitions from: %i[rejected draft waiting_for_payment], to: :moderation
    end

    event :publish do
      transitions from: :moderation, to: :published
    end

    event :reject do
      transitions from: :moderation, to: :rejected
    end

    event :hide do
      transitions from: :published, to: :hidden
    end

    event :complete do
      transitions from: %i[hidden published], to: :completed
    end
  end

  def initialize(attrs = nil)
    defaults = {
      base_customer_price: 0,
      base_contractor_price: 0,
      customer_price: 0,
      contractor_price: 0,
      customer_total: 0,
      contractor_total: 0,
      warranty_period: 10,
      other_info: {
        age_from: nil,
        age_to: nil,
        remark: nil,
        sex: nil,
        terms: nil,
        related_profession: nil
      }
    }
    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

  def can_be_paid?
    balance.amount >= customer_total
  end

  def calculate_total
    customer_price * number_of_employees
  end

  def selected_candidates
    candidates.select { |c| c.hired? || c.disputed? }
  end

  def to_draft
    return unless may_cancel?
    if moderation?
      balance.deposit(customer_total, "Возврат оплаты за публикацию заявки №#{id}. Причина: публикация отменена пользователем.")
    end
    cancel!
  end

  def to_waiting_for_payment
    wait_for_payment! if may_wait_for_payment?
  end

  def to_moderation
    return unless balance.withdraw(customer_total, "Публикация заявки #{id}")
    moderate! if may_moderate?
  end

  def to_published
    return unless may_publish?
    publish!
    comments.create(text: 'Заявка допущена к публикации')
  end

  def to_rejected(reason)
    return unless may_reject?
    reject!
    comments.create(text: reason)
    balance.deposit(customer_total, "Возврат оплаты за публикацию заявки №#{id}. Причина: заявка не прошла модерацию.")
  end

  def to_hidden
    hide! if may_hide?
  end

  def to_completed
    complete! if may_complete?
  end

  def balance
    profile.balance
  end

  def proposal_by_profile_id(profile_id)
    Proposal.find_by(order_id: id, profile_id: profile_id)
  end
end
