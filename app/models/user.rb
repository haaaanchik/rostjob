class User < ApplicationRecord
  belongs_to :profile

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :omniauthable

  def self.find_or_register_facebook_oauth access_token
    if user = User.find_by(provider: access_token.provider, uid: access_token.uid)
      user
    else
      info = access_token.info
      result = ::UserProfile::Create.call(profile_params: { contact_person: info.name, photo_url: info.image, email: info.email })
      if result.success?
        User.create!(provider: access_token.provider, uid: access_token.uid,  full_name: info.name, photo_url: info.image,
                     email: info.email, password:  Devise.friendly_token[0,20],
                     profile_id: result.profile.id)
      else
      end
    end
  end

  def self.find_or_register_vkontakte_oauth access_token
    if user = User.find_by(provider: access_token.provider, uid: access_token.uid)
      user
    else
      info = access_token.info
      result = ::UserProfile::Create.call(profile_params: { contact_person: info.name, photo_url: info.image })
      if result.success?
        User.create!(provider: access_token.provider, uid: access_token.uid, full_name: info.name, photo_url: info.image,
                     email: "#{access_token.uid}@vk.com", password: Devise.friendly_token[0,20],
                     profile_id: result.profile.id)
      else
      end
    end
  end
end
