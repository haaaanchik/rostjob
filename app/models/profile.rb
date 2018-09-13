class Profile < ApplicationRecord
  include AASM
  extend ConditionalValidation::ValidationFlag

  has_many :users
  has_many :orders
  has_many :proposals
  has_one :balance
  has_many :invoices

  validation_flag :sm_registration

  PROFILE_TYPES = %w[employer agency recruiter employee].freeze
  COMPANIES = %w[employer agency].freeze

  validates :contact_person, presence: true
  with_options unless: :validate_on_sm_registration? do |o|
    o.validates :phone, presence: true
    o.validates :email, presence: true
    o.validates :company_name, presence: true, if: Proc.new { |p| COMPANIES.include? p.profile_type }
    o.validates :profile_type, presence: true, inclusion: { in: PROFILE_TYPES }
  end

  has_attached_file :photo, styles: { medium: "100x100>", thumb: "50x50" }, default_url: "/img/default.png"
  validates_attachment_content_type :photo, content_type: ["image/jpeg", "image/gif", "image/png"]

  scope :executors, -> { where profile_type: %w[agency recruiter] }
  scope :by_query, -> (term) { where('contact_person LIKE ? OR description LIKE ?', "%#{term}%", "%#{term}%") }

  aasm column: :state do
    state :created, initial: true
    state :filled
    state :deleted

    event :fill do
      transitions from: :created, to: :filled
    end

    event :delete_profile do
      transitions from: %i[created filled], to: :deleted
    end
  end
end
