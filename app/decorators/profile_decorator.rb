class ProfileDecorator < ObjDecorator
  delegate_all

  def order_titles
    orders.published.map(&:title).uniq.join(', ')
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
end
