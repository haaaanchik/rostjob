class ProfileDecorator < ObjDecorator
  delegate_all

  def order_cities
    orders.published.map(&:city).uniq.join(', ')
  end

  def order_titles
    orders.published.map(&:title).uniq.join(', ')
  end

  def role_in_budge
    color = model.customer? ? 'primary' : 'secondary'
    status_name = h.t("profile.profile_type.#{model.profile_type}")
    h.content_tag(:span, status_name, class: "badge badge-#{color}")
  end
end
