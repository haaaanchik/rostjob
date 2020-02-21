class Order < ApplicationRecord
  include AASM
  include OrderRepository
  include Order::OrderTemplatable
  extend Enumerize

  enumerize :urgency, in: %i[low middle high], scope: true, default: :middle
  enumerize :urgency_level, in: { low: 0, middle: 1, high: 2 }, scope: true

  belongs_to :profile
  belongs_to :production_site
  belongs_to :position
  has_many :invites
  has_many :candidates, class_name: 'ProposalEmployee'
  has_many :comments, dependent: :destroy
  has_many :proposals
  has_many :proposal_employees
  has_many :profiles, -> { distinct }, through: :proposal_employees
  has_many :order_profiles
  has_many :employee_cvs, through: :proposal_employees, source: :employee_cv
  has_one  :user, through: :profile

  validates :customer_price, :contractor_price, :customer_total, :contractor_total,
            presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :number_of_employees, presence: true, numericality: {only_integer: true}

  has_attached_file :document
  validates_attachment_content_type :document, content_type: /.*\/.*\z/

  ransack_alias :all_fields, :id_or_title_or_description_or_city_or_place_of_work_or_salary_from_or_salary_to
  ransack_alias :candidate_fields, :id_or_title_or_place_of_work_or_employee_cv_name
  ransack_alias :title_fields, :title
  ransack_alias :city_fields, :production_site_city

  ransacker :id do
    Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
  end

  ransacker :salary_from do
    Arel.sql("CONVERT(#{table_name}.salary_from, CHAR(8))")
  end

  ransacker :salary_to do
    Arel.sql("CONVERT(#{table_name}.salary_to, CHAR(8))")
  end

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

    event :moderate, after: :send_mail_order_is_moderate do
      transitions from: %i[rejected draft waiting_for_payment], to: :moderation
    end

    event :publish do
      transitions from: %i[moderation completed], to: :published
    end

    event :reject do
      transitions from: :moderation, to: :rejected
    end

    event :hide do
      transitions from: :published, to: :hidden
    end

    event :complete, after: :refund_amount do
      transitions from: %i[hidden published], to: :completed
    end
  end

  def initialize(attrs = nil)
    defaults = default_init

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

  def title_with_id
    "#{id} #{title}"
  end

  def number_free_places
    number_of_employees - without_inbox_candidate_count
  end

  def refund_amount
    remaining_places = number_free_places
    return if remaining_places <= 0
    Cmd::Order::Refund.call(remaining_places: remaining_places, order: self)
  end

  def without_inbox_candidate_count
    proposal_employees.where.not('proposal_employees.state': ['inbox', 'paid']).count
  end

  def to_close?
    return if number_free_places > 0
    to_completed
    Cmd::UserActionLogger::Log.call(params: logger_params("Заявка №#{id} #{title} завершена"))
    OrderMailJob.perform_later(order: self, method: 'completed')
  end

  def to_open?
    return if number_free_places <= 0
    to_published
    Cmd::UserActionLogger::Log.call(params: logger_params("Заявка №#{id} #{title} опубликована"))
    OrderMailJob.perform_later(order: self, method: 'published')
  end

  private

  def logger_params(action_title)
    {
      login: user.email,
      receiver_ids: [user.id],
      subject_id: user.id,
      subject_type: 'User',
      subject_role: profile.profile_type,
      action: action_title,
      object_id: id,
      object_type: 'Order',
      order_id: id
    }
  end

  def send_mail_wait_for_payment
    SendEveryDaysNotifyMailJob.perform_now(objects: [self], method: 'order_wait_for_payment')
  end

  def send_mail_order_is_moderate
    SendModerationMailJob.perform_now(order: self)
  end
end
