module UsersHelper
  def label_full_name(user)
    if user.profile.contractor?
      'Название профиля'
    else
      'Название организации'
    end
  end

  def navside_logo
    contractor? ?  'navside/user-logo.png' : 'navside/user-avatar.png'
  end

  def navbar_ronded
    contractor? ?  'navbar/Rounded_Rectangle_blue.png' : 'navbar/Rounded_Rectangle_purple.png'
  end

  def dispute
    contractor? ?  '/img/new/smile-sow.png' : 'smile_sow.png'
  end

  def roles_for_selector
    [['Все', ''], ['Исполнитель', 'contractor'], ['Заказчик', 'customer']]
  end

  def registration_user_path
    role = request.url.include?('freelance') ? 'contractor' : 'customer'

    user_registration_path(role: role)
  end
end
