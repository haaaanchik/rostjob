class OrderTemplateDecorator < ApplicationDecorator
  delegate_all

  def back_url_from_second_step(production_site)
    h.first_step_profile_production_site_order_template_path(production_site, object)
  end

  def back_url_from_third_step(production_site)
    h.second_step_profile_production_site_order_template_path(production_site, object)
  end

  def first_step_next_link(production_site)
    h.content_tag(:a, href: h.second_step_profile_production_site_order_path(production_site, object)) do
      h.content_tag(:p) { 'Далее' }
    end
  end
end
