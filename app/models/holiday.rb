class Holiday < ApplicationRecord
  WARRANTY_PERIOD = 10

  validates :date, presence: true

  scope :holidays, ->(hiring_date) { where date: hiring_date..(hiring_date + 1.month).end_of_month }

  def self.warranty_date(hiring_date)
    working_days_count = 1
    h_days = holidays(hiring_date)
    working_date = hiring_date
    while working_days_count < WARRANTY_PERIOD
      working_date += 1.day
      working_days_count += 1 unless h_days.any? { |h| h.date == working_date }
    end
    working_date
  end

  def self.remained_warranty_days(hiring_date, warranty_date)
    remained_days = []
    return remained_days unless hiring_date
    today = Date.today
    h_days = holidays(hiring_date)
    working_date = warranty_date
    while working_date >= today
      remained_days.push working_date.strftime('%d-%m-%Y') unless h_days.any? { |h| h.date == working_date }
      working_date -= 1.day
    end
    remained_days
  end
end
