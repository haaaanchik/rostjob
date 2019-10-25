module EmployeeCvRepository
  extend ActiveSupport::Concern

  included do
    scope :proposed, -> { where(state: %w[hired applyed]) }
    scope :available, ->(profile_id) { where(state: %w[ready applyed], profile_id: profile_id) }
    scope :available_free, ->(profile_id, _proposal_id) { available(profile_id).where('proposal_id IS NULL') }

    scope :created_today, -> {
      where 'created_at >= ? and created_at <= ?', Time.current.beginning_of_day, Time.current.end_of_day
    }
    scope :created_last_2days, -> {
      where 'created_at >= ? and created_at <= ?', Time.current.beginning_of_day - 2.day, Time.current.end_of_day - 1.day
    }
    scope :created_last_3days, -> {
      where 'created_at >= ? and created_at <= ?', Time.current.beginning_of_day - 3.days, Time.current.end_of_day - 1.day
    }
    scope :created_last_7days, -> {
      where 'created_at >= ? and created_at <= ?', Time.current.beginning_of_day - 7.days, Time.current.end_of_day - 1.day
    }
    scope :created_last_14days, -> {
      where 'created_at >= ? and created_at <= ?', Time.current.beginning_of_day - 14.days, Time.current.end_of_day - 1.day
    }
    scope :created_last_1month, -> {
      where 'created_at >= ? and created_at <= ?', Time.current.beginning_of_day - 1.month, Time.current.end_of_day - 1.day
    }
    scope :with_reminders, -> {
      where('reminder > ?', Time.current - 3.days).order(:reminder)
    }
    scope :without_reminders, -> {
      where('reminder < ? or reminder IS ?', Time.current - 3.days, nil)
    }
  end
end
