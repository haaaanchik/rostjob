module UsersHelper
  def label_full_name(user)
    if user.profile.contractor?
      'Название профиля'
    else
      'Название организации'
    end
  end
end
