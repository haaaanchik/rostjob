class Profile < ApplicationRecord
  # extend Enumerize
  include AASM

  has_many :users
  has_many :orders
  has_many :proposals

  PROFILE_TYPES = %w[employer agency recruiter employee].freeze
  COMPANIES = %w[employer agency].freeze

  validates :contact_person, presence: true
  validates :phone, presence: true, on: :default_registration
  validates :email, presence: true, on: :default_registration
  validates :contact_person, presence: true, on: :default_registration
  validates :company_name, presence: true, if: Proc.new { |p| COMPANIES.include? p.profile_type }, on: :default_registration
  validates :profile_type, presence: true, inclusion: { in: PROFILE_TYPES }, on: :default_registration

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
  # enumerize :profile_type , in: %i[employer agency recruter employee]
end
