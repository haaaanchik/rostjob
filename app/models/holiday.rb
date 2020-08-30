class Holiday < ApplicationRecord
  WARRANTY_PERIOD = 10

  validates :date, presence: true

  scope :holidays, ->(hiring_date) { where date: (hiring_date - 1.month).beginning_of_month..(hiring_date + 1.month).end_of_month }

  def self.warranty_date(hiring_date, warranty_period)
    add_working_days(hiring_date, warranty_period)
  end

  def self.plus_five_working_days(date)
    add_working_days(date, 6)
  end

  def self.minus_five_working_days(date)
    subtract_working_days(date, 6)
  end

  def self.remained_warranty_days(hiring_date, warranty_date)
    remained_days = []
    return remained_days unless hiring_date
    today = Date.today < hiring_date ? hiring_date : Date.today
    h_days = holidays(hiring_date)
    working_date = warranty_date
    while working_date >= today
      remained_days.push working_date.strftime('%d-%m-%Y') unless h_days.any? { |h| h.date == working_date }
      working_date -= 1.day
    end
    remained_days
  end

  def self.add_working_days(start_date, days_count)
    working_days_count = 0
    h_days = holidays(start_date)
    working_date = start_date
    working_days_count += 1 unless h_days.any? { |h| h.date == working_date }
    while working_days_count < days_count
      working_date += 1.day
      working_days_count += 1 unless h_days.any? { |h| h.date == working_date }
    end
    working_date
  end

  def self.subtract_working_days(start_date, days_count)
    working_days_count = 0
    h_days = holidays(start_date)
    working_date = start_date
    working_days_count += 1 unless h_days.any? { |h| h.date == working_date }
    while working_days_count < days_count
      working_date -= 1.day
      working_days_count += 1 unless h_days.any? { |h| h.date == working_date }
    end
    working_date
  end
end
