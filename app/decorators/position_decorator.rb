# frozen_string_literal: true

class PositionDecorator < ApplicationDecorator
  def display_price
    price_group.customer_price.to_i
  end

  def display_link_title
    return title if slug.blank?

    h.link_to(title, h.professions_path(slug))
  end

  def display_other_services
    return h.cookies[:other_services] if h.cookies[:other_services].present?

    service_list = [(h.link_to 'hh.ru', 'https://hh.ru'), (h.link_to 'superjob.ru', 'https://superjob.ru'),
                    (h.link_to 'avito.ru', 'https://avito.ru'), (h.link_to 'careerist.ru', 'https://careerist.ru'),
                    (h.link_to 'zarplata.ru', 'https://zarplata.ru'), (h.link_to 'работа.ру', 'https://rabota.ru')]
    h.cookies[:other_services] = service_list.shuffle.join(', ')
  end
end
