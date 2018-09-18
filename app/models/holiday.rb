class Holiday < ApplicationRecord
  WARRANTY_PERIOD = 10

  validates :date, presence: true

  scope :holidays, ->(hiring_date) { where date: hiring_date..(hiring_date + 1.month).end_of_month }

  def self.warranty_date(hiring_date)
    working_days_count = WARRANTY_PERIOD
    h_days = holidays(hiring_date)
    working_date = hiring_date
    while working_days_count.positive?
      working_date += 1.day
      working_days_count -= 1 unless h_days.any? { |h| h.date == working_date }
    end
    working_date
  end
end
