class Profile < ApplicationRecord
  include AASM
  extend ConditionalValidation::ValidationFlag

  has_one :user, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :proposals
  has_one :balance, dependent: :destroy
  has_one :company, as: :companyable, dependent: :destroy
  has_many :invoices
  has_many :tax_calculations
  has_many :proposal_employees
  has_many :customer_proposal_employees, through: :orders, source: :proposal_employees
  has_many :answered_orders, -> { distinct }, through: :proposal_employees, source: :order
  has_many :employee_cvs
  has_many :order_profiles
  has_many :favorites, through: :order_profiles, source: :order
  has_many :order_templates, dependent: :destroy
  has_many :withdrawal_methods, dependent: :destroy
  has_many :complaints, dependent: :destroy
  has_many :production_sites, dependent: :destroy

  attr_accessor :sent_proposal_employees

  accepts_nested_attributes_for :company

  validation_flag :sm_registration

  PROFILE_TYPES = %w[customer contractor].freeze

  validates :profile_type, presence: true, inclusion: { in: PROFILE_TYPES }

  has_attached_file :photo, styles: { medium: "100x100>", thumb: "50x50" }, default_url: "/img/default.png"
  validates_attachment_content_type :photo, content_type: ["image/jpeg", "image/gif", "image/png"]

  ransack_alias :all_fields, :user_full_name
  ransack_alias :title_fields, :orders_title
  ransack_alias :city_fields,  :orders_city

  scope :executors, -> { where profile_type: %w[agency recruiter] }
  scope :by_query, ->(term) { where('contact_person LIKE ? OR description LIKE ?', "%#{term}%", "%#{term}%") }
  scope :contractors, -> { where profile_type: 'contractor' }
  scope :contractors_companies, -> { contractors.where legal_form: 'company' }
  scope :contractors_private_persons, -> { contractors.where legal_form: 'private_person' }
  scope :customers, -> { where(profile_type: 'customer') }

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

  def image_url
    photo? ? photo.url : '/img/new/no-avatar.png'
  end

  def orders_with_paid_employees(current_date, prev_date)
    answered_orders.where('proposal_employees.state = ? and
                           proposal_employees.payment_date < ? and
                           proposal_employees.payment_date > ? ',
                          'paid', current_date, prev_date)
  end

  def free_manager?
    manager? && free?
  end

  def free?
    result = Cmd::FreeManager::Get.call(user_id: user.id)
    return true if result.manager

    result.manager
  end

  def manager?
    contractor? && manager
  end

  def private_person?
    legal_form == 'private_person'
  end

  def company?
    legal_form == 'company'
  end

  def customer?
    profile_type == 'customer'
  end

  def contractor?
    profile_type == 'contractor'
  end

  def subject_type
    profile_type
  end

  def customer_can_only_be_a_company
    return if customer? && company?
    errors.add(:base, 'customer can only be a company')
  end

  def private_person_can_only_be_a_contractor
    return if private_person? && contractor?
    errors.add(:base, 'private person can only be a contractor')
  end

  def sent_proposal_employees_by_order(order)
    proposal_employees.where(order_id: order).where.not(state: 'revoked')
  end

  def filled?
    true if company
  end
end
