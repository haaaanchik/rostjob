class ProfileDecorator < ObjDecorator
  delegate_all

  def order_titles_count
    orders.published.count
  end

  def role_in_budge
    color = model.customer? ? 'primary' : 'secondary'
    status_name = h.t("profile.profile_type.#{model.profile_type}")
    h.content_tag(:span, status_name, class: "badge badge-#{color}")
  end

  def active_link_edit_profile
    label = customer? ? 'Карточка предприятия' : 'Данные партнера'

    h.active_link_to label,
                      h.edit_profile_path,
                      class_active: 'active-link'
    end

  def active_link_term_of_uses
    return if contractor?


    h.content_tag :li do
      h.link_to('Правила пользования', h.term_of_uses_path, class_active: 'active-link')
    end
  end

  # def display_text_new_order
  #   date = orders.published.maximum(:published_at)
  #   return if (date <= Date.current.days_ago(14.days))
  # 
  #   'Новая заявка'
  # end
end
