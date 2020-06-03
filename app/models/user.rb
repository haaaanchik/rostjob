class User < ApplicationRecord
  include UserRepository

  attr_accessor :skip_validation_full_name, :skip_validation_password

  before_validation :set_guid, on: :create
  belongs_to :profile, optional: true
  has_one :balance, through: :profile
  has_many :user_action_logs, as: :subject

  accepts_nested_attributes_for :profile
  ransack_alias :admin_search_fields, :full_name_or_id_or_email_or_profile_phone

  validates :full_name, presence: true, length: { minimum: 8 }, if: -> { !skip_validation_full_name }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, presence: true, on: :update, if: -> { !skip_validation_password }

  devise :database_authenticatable, :registerable, :recoverable, :trackable,
         :validatable, :omniauthable, :confirmable, :rememberable,
         omniauth_providers: %i[vkontakte facebook]

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

  def set_guid
    self.guid = SecureRandom.uuid
  end

  def active_for_authentication?
    super && is_active?
  end

  def inactive_message
    'Ваша учётная запись заблокирована. Для восстановления доступа обратитесь к менеджеру по email: manager@rostjob.com'
  end

  def password_required?
    super if confirmed?
  end

  def update_without_curr_password(params)
    self.skip_validation_full_name = false
    result = update(params)
    if result
      update_attribute(:password_changed_at, DateTime.now)
      SendDirectMailJob.perform_now(user: self, method: 'welcome_message') if profile.contractor?
    end
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
