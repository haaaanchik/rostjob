class Order < ApplicationRecord
  include AASM

  belongs_to :profile
  has_many :invites
  has_many :proposals
  has_many :candidates, class_name: 'EmployeeCv'
  has_many :comments

  validates :title, presence: true
  validates :customer_price, :contractor_price, :total,
            presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :contractor_price, presence: true, numericality: { only_integer: true }
  validates :number_of_employees, presence: true, numericality: { only_integer: true }
  validates :specialization, presence: true
  validates :city, presence: true
  validates :salary_from, presence: true, numericality: { only_integer: true }
  validates :salary_to, presence: true, numericality: { only_integer: true }
  validates :description, presence: true
  # validates :commission, presence: true, numericality: { only_integer: true }
  # validates :payment_type, presence: true
  validates :warranty_period, presence: true, numericality: { only_integer: true }
  # validates :number_of_recruiters, presence: true, numericality: { only_integer: true }
  validates :accepted, acceptance: { message: 'must be abided' }

  scope :filter_by_day, -> { where 'created_at >= ?', Date.today - 1.day }
  scope :filter_by_3day, -> { where 'created_at >= ?', Date.today - 3.days }
  scope :filter_by_week, -> { where 'created_at >= ?', Date.today - 1.week }
  scope :filter_by_all_time, -> { all }
  scope :sort_by_reward_asc, -> { order commission: :asc }
  scope :sort_by_reward_desc, -> { order commission: :desc }
  scope :sort_by_date_asc, -> { order created_at: :asc }
  scope :sort_by_date_desc, -> { order created_at: :desc }
  scope :by_query, ->(term) { where('title LIKE ? OR description LIKE ?', "%#{term}%", "%#{term}%") }

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: false do
    state :draft, initial: true
    state :moderation
    state :published
    state :rejected
    state :hidden
    state :completed

    event :to_moderation do
      transitions from: %i[draft rejected hidden], to: :moderation
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

  def customer_price
    self[:customer_price] || 0
  end

  def contractor_price
    self[:contractor_price] || 0
  end

  def total
    self[:total] || 0
  end

  def warranty_period
    self[:warranty_period] || 10
  end

  def calculate_total
    customer_price * number_of_employees
  end

  def summ
    commission * number_of_employees
  end

  def selected_candidates
    candidates.select { |c| c.hired? || c.fired? }
  end
end
