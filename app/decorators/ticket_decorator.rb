class TicketDecorator < ApplicationDecorator
  # frozen_string_literal: true

  delegate_all

  def header
    'Это заголовок'
  end

  def subject_name
    model.user.full_name
  end

  def hire_action_enabled?(_subject)
    false
  end

  def revoke_action_enabled?(_subject)
    false
  end

  def to_inbox_action_enabled?(_subject)
    false
  end

  def close_action_enabled?(_subject)
    false
  end

  def user_full_name
    return if object.proposal_employee.nil?
    object.proposal_employee.profile.user.full_name
  end

  def display_appeal_and_incident
    return h.content_tag(:i, '', class: 'i fas fa-file-alt', title: 'Обращение') if ticket.appeal?
    return h.content_tag(:i, '', class: 'i fas fa-angry', title: 'Спор') if ticket.incident?
  end

  def display_order_title
    return if appeal?

    "№#{proposal_employee.order.id} #{proposal_employee.order.title}"
  end

  def display_proposal_employee_name
    return if appeal?

    proposal_employee.employee_cv.name
  end

  def display_candidate_price(user)
    return proposal_employee.order.customer_price if user.profile.customer?

    proposal_employee.order.contractor_price
  end

  def display_customer_order_url(order)
    return h.content_tag(:div, order.title) if h.current_profile.contractor?

    h.link_to order.title,
              h.profile_production_site_order_path(order.production_site,
                                                   order),
              class: 'black-text'
  end

end
