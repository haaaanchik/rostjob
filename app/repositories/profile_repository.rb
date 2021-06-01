# frozen_string_literal: true

module ProfileRepository
  extend ActiveSupport::Concern

  included do
    scope :executors, -> { where profile_type: %w[agency recruiter] }
    scope :by_query, ->(term) { where('contact_person LIKE ? OR description LIKE ?', "%#{term}%", "%#{term}%") }
    scope :contractors, -> { where profile_type: 'contractor' }
    scope :contractors_companies, -> { contractors.where legal_form: 'company' }
    scope :contractors_private_persons, -> { contractors.where legal_form: 'private_person' }
    scope :customers, -> { where(profile_type: 'customer') }
  end
end
