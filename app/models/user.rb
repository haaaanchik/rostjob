class User < ApplicationRecord
  before_validation :set_guid, on: :create
  # before_validation :fill_from_profile, on: :create
  belongs_to :profile, optional: true
  # accepts_nested_attributes_for :profile, reject_if: :all_blank
  has_one :balance, through: :profile

  validates :full_name, presence: true, length: {minimum: 8}
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, presence: true
  validates :terms_of_service, acceptance: true

  # devise :registerable, :confirmable, :recoverable, :trackable, :validatable,
  #        :omniauthable, omniauth_providers: [:vkontakte, :facebook]

  devise :database_authenticatable, :registerable, :recoverable, :trackable,
         :validatable, :omniauthable, :confirmable,
         omniauth_providers: %i[vkontakte facebook]

  # devise :database_authenticatable, :registerable, :recoverable, :trackable,
  #        :validatable, :omniauthable,
  #        omniauth_providers: [:vkontakte, :facebook]

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

  private

  def fill_from_profile
    return unless profile
    Rails.logger.debug "<<<<<<<<< 1"
    self.email = profile.email
    self.full_name = profile.contact_person

    Rails.logger.debug "<<<<<<<<< #{self.attributes}"
  end
end
