module UsersHelper
  def label_full_name(user)
    if user.profile.contractor?
      'Название профиля'
    else
      'Название организации'
    end
  end

  def roles_for_selector
    [['Все', ''], ['Исполнитель', 'contractor'], ['Заказчик', 'customer']]
  end

  def link_to_show_password_block(user)
    return unless user.password_changed_at.present? 

    link_to 'Ввести пароль', '#', class: 'submit mb-3 mt-1', id: 'show_password_block'
  end
end
