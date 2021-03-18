module EmployeeCvRepository
  extend ActiveSupport::Concern

  included do
    scope :proposed, -> { where(state: %w[hired applyed]) }
    scope :available, ->(profile_id) { where(state: %w[ready applyed], profile_id: profile_id) }
    scope :available_free, ->(profile_id, _proposal_id) { available(profile_id).where('proposal_id IS NULL') }
    scope :range_reminders, -> (start_date, end_date){ where('reminder > ? AND reminder < ?', start_date, end_date)}
    scope :with_reminders, -> {
      where.not(reminder: nil).order(:reminder)
    }
    scope :without_reminders, -> {
      where(reminder: nil).order(id: :desc)
    }
  end
end
