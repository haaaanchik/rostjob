class User < ApplicationRecord
  belongs_to :profile

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :omniauthable

  def self.find_or_register_facebook_oauth access_token
    if user = User.where(:url => access_token.info.urls.Facebook).first
      user
    else
      result = ::UserProfile::Create.call(profile_params: { contact_person: access_token.info.name })
      if result.success?
        User.create!(provider: access_token.provider, url: access_token.info.urls.Facebook, full_rname: access_token.info.name,
                     email: access_token.extra.raw_info.email, password:  Devise.friendly_token[0,20])
      else
      end
    end
  end

  def self.find_or_register_vkontakte_oauth access_token
    if user = User.where(:url => access_token.info.urls.Vkontakte).first
      user
    else
      result = ::UserProfile::Create.call(profile_params: { contact_person: access_token.info.name })
      if result.success?
        User.create!(provider: access_token.provider, url: access_token.info.urls.Vkontakte, full_name: access_token.info.name,
                     email: "#{access_token.extra.raw_info.screen_name}@vk.com", password: Devise.friendly_token[0,20],
                     profile_id: result.profile.id)
      else
      end
    end
  end
end
