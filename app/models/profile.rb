class Profile < ApplicationRecord
  include AASM

  has_many :users
  has_many :orders
  has_many :proposals

  PROFILE_TYPES = %w[employer agency recruiter employee].freeze
  COMPANIES = %w[employer agency].freeze

  validates :contact_person, presence: true
  validates :phone, presence: true, on: :default_registration
  validates :email, presence: true, on: :default_registration
  validates :company_name, presence: true, if: Proc.new { |p| COMPANIES.include? p.profile_type }, on: :default_registration
  validates :profile_type, presence: true, inclusion: { in: PROFILE_TYPES }, on: :default_registration

  has_attached_file :photo, styles: { medium: "300x300>", thumb: "50x50" }, default_url: "/img/default.jpg"
    # path: ":rails_root/storage/:class/:attachment/:id_partition/:style/:filename",
    # url: "storage/:class/:attachment/:id_partition/:style/:filename",
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
