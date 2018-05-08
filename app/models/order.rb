class Order < ApplicationRecord
  include AASM

  belongs_to :profile
  has_many :invites
  has_many :proposals

  validates :title, presence: true
  validates :specialization, presence: true
  validates :city, presence: true
  validates :salary_from, presence: true
  validates :salary_to, presence: true
  validates :description, presence: true
  validates :commission, presence: true
  validates :payment_type, presence: true
  validates :warranty_period, presence: true
  validates :number_of_recruiters, presence: true
  validates :accepted, presence: true

  scope :filter_by_day, -> { where 'created_at >= ?', Date.today - 1.day }
  scope :filter_by_3day, -> { where 'created_at >= ?', Date.today - 3.days }
  scope :filter_by_week, -> { where 'created_at >= ?', Date.today - 1.week }
  scope :filter_by_all_time, -> { all }
  scope :sort_by_reward_asc, -> { order commission: :asc }
  scope :sort_by_reward_desc, -> { order commission: :desc }
  scope :sort_by_date_asc, -> { order created_at: :asc }
  scope :sort_by_date_desc, -> { order created_at: :desc }
  scope :by_query, -> (term) { where('title LIKE ? OR description LIKE ?', "%#{term}%", "%#{term}%") }

  aasm column: :state, skip_validation_on_save: true, no_direct_assignment: false do
    state :hidden, initial: true
    state :published
    state :completed

    event :publish do
      transitions from: :hidden, to: :published
    end

    event :hide do
      transitions from: :published, to: :hidden
    end

    event :complete do
      transitions from: %i[hidden published], to: :completed
    end
  end
end
