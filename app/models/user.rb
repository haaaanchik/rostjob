class User < ApplicationRecord
  attr_accessor :skip_validation_full_name

  before_validation :set_guid, on: :create
  belongs_to :profile, optional: true
  has_one :balance, through: :profile

  validates :full_name, presence: true, length: { minimum: 8 }, if: -> { !skip_validation_full_name }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, presence: true, on: :update

  devise :database_authenticatable, :registerable, :recoverable, :trackable,
         :validatable, :omniauthable, :confirmable, :rememberable,
         omniauth_providers: %i[vkontakte facebook]

  scope :clients, -> {
    select(:id, :full_name, :amount, :profile_type, :employee_cvs_count, :orders_count)
      .joins(:balance)
      .joins('left join (select profile_id, count(profile_id) as employee_cvs_count from employee_cvs group by profile_id) e on profiles.id = e.profile_id')
      .joins('left join (select profile_id, count(profile_id) as orders_count from orders group by profile_id) o on profiles.id = o.profile_id')
  }
  scope :customers, -> { clients.where('profiles.profile_type = ?', 'customer') }
  scope :contractors, -> { clients.where('profiles.profile_type = ?', 'contractor') }
  scope :sort_by_amount_asc, -> { order('amount asc') }
  scope :sort_by_amount_desc, -> { order('amount desc') }
  scope :sort_by_orders_count_asc, -> { order('orders_count asc') }
  scope :sort_by_orders_count_desc, -> { order('orders_count desc') }
  scope :sort_by_employee_cvs_count_asc, -> { order('employee_cvs_count asc') }
  scope :sort_by_employee_cvs_count_desc, -> { order('employee_cvs_count desc') }

  def initialize(attrs = nil)
    defaults = {
      is_active: true
    }

    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

  def self.find_or_create_by_auth(auth)
    User.find_or_create_by(uid: auth['uid']) do |u|
      u.provider = auth['profider']
      u.full_name = auth['info']['name']
      u.email = auth['provider'] == 'vkontakte' ? "#{auth['uid']}@vk.com" : auth['info']['email']
      u.image = auth['info']['image']
      u.password = SecureRandom.hex
    end
  end

  ransacker :id do
    Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
  end

  # def self.find_or_register_facebook_oauth access_token
  #   if user = User.find_by(provider: access_token.provider, uid: access_token.uid)
  #     user
  #   else
  #     info = access_token.info
  #     result = ::UserProfile::Create.call(sm_registration: true, profile_params: { contact_person: info.name, photo_url: info.image, email: info.email })
  #     if result.success?
  #       User.create!(provider: access_token.provider, uid: access_token.uid,  full_name: info.name, photo_url: info.image,
  #                    email: info.email, password:  Devise.friendly_token[0,20],
  #                    profile_id: result.profile.id)
  #     else
  #     end
  #   end
  # end

  # def self.find_or_register_vkontakte_oauth access_token
  #   if user = User.find_by(provider: access_token.provider, uid: access_token.uid)
  #     user
  #   else
  #     info = access_token.info
  #     result = ::UserProfile::Create.call(sm_registration: true, profile_params: { contact_person: info.name, photo_url: info.image })
  #     if result.success?
  #       User.create!(provider: access_token.provider, uid: access_token.uid, full_name: info.name, photo_url: info.image,
  #                    email: "#{access_token.uid}@vk.com", password: Devise.friendly_token[0,20],
  #                    profile_id: result.profile.id)
  #     else
  #     end
  #   end
  # end

  def set_guid
    self.guid = SecureRandom.uuid
  end

  def active_for_authentication?
    super && is_active?
  end

  def inactive_message
    'Ваша учётная запись заблокирована. Для восстановления доступа обратитесь к менеджеру по email: manager@best-hr.pro'
  end

  def password_required?
    super if confirmed?
  end

  def update_without_curr_password(params)
    self.skip_validation_full_name = false
    result = update(params)
    update_attribute(:password_changed_at, DateTime.now) if result
    clean_up_passwords
    result
  end

  def accept_terms
    update_attribute(:terms_of_service, true)
  end

  def reset_password(new_password, new_password_confirmation)
    self.skip_validation_full_name = true
    super
  end

  private

  def fill_from_profile
    return unless profile
    Rails.logger.debug "<<<<<<<<< 1"
    self.email = profile.email
    self.full_name = profile.contact_person

    Rails.logger.debug "<<<<<<<<< #{self.attributes}"
  end
end
