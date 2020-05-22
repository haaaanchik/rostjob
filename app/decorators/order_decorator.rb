class OrderDecorator < ApplicationDecorator
  delegate_all

  def order_id
    model.id
  end

  def urgency_title
    'Срочность заявки ' + I18n.t("enumerize.order.urgency.#{model.urgency}")
  end

  def urgency_low_class
    'text-info'
  end

  def urgency_middle_class
    model.urgency.middle? || model.urgency.high? ? 'text-warning' : 'invisible'
  end

  def urgency_high_class
    model.urgency.high? ? 'text-danger' : 'invisible'
  end

  def title_with_skill
    "№#{id} #{title}. #{skill}"
  end

  def icon_bookmark(active_id)
    h.content_tag(:i, class: "ml-2 mr-1 #{'fas fa-bookmark' if id == active_id}") {}
  end

  def icon_chevron_or_minus
    reversed = proposal_employees.reserved.count
    h.content_tag(:i, class: "ml-2 mr-1 blue-text fas #{ reversed.zero? ? 'fa-minus' : 'fa-chevron-up'}") {}
  end

  def proposal_employees_by_status(state)
    order_by = state == 'hired' ? 'hiring_date' : 'interview_date'
    proposal_employees.includes(:employee_cv, profile: :user).send(state).order(order_by.to_sym)
  end

  def without_paid_revoked_employees
    proposal_employees.where.not(state: %w(paid revoked))
                      .where(profile: h.current_profile )
                      .includes(:employee_cv)
  end

  def fix_display_order_disputed
    return unless candidates.disputed.present?
    h.content_tag(:a,
                  href: h.profile_tickets_path,
                  class:'red-text') {" + #{ candidates.disputed.count} спор(ов)"}

  end

  def total_price
    return customer_total if number_additional_employees.nil?
    number_additional_employees.to_i * customer_price
  end

  def replenish_balance?
    return can_be_paid? if number_additional_employees.nil?
    employees_can_be_paid?
  end

  def link_button
    case
    when employees_can_be_paid?
      h.content_tag(:a,
                    href: h.add_additional_employees_profile_production_site_order_path(production_site, object),
                    class: 'public',
                    data: { method: :put }) { 'Оплатить' }
    when !replenish_balance?
      h.content_tag(:a,
                    href: h.profile_invoices_path(params: { amount: total_price - balance.amount }),
                    class: 'public') { 'Пополнить баланс' }
    else
      h.content_tag(:span, id: 'order_publish',
                    class: 'public') { 'Опубликовать' }
    end
  end

  def link_cancel_publish(production_site)
    return unless number_additional_employees.nil?
    h.content_tag(:a,
                  href: h.cancel_profile_production_site_order_path(production_site, object),
                  class: 'cancel',
                  data: { confirm: 'Вы действительно хотите отменить публикацию? заявка будет удаленаю полностью.',
                          method: :put,
                          remote: true }) { 'Отменить' }
  end

  def publish_title
    title_text = !replenish_balance? ? 'Недостаточно средств' : 'Публикация заявки'
    klass =  !replenish_balance? ? 'page-title red-text' : 'page-title'
    h.content_tag(:h1, class: klass) { title_text }
  end

  def back_url_from_second_step(production_site)
    h.first_step_profile_production_site_order_path(production_site, object)
  end

  def back_url_from_third_step(production_site)
    h.second_step_profile_production_site_order_path(production_site, object)
  end

  def first_step_next_link(production_site)
    h.content_tag(:a, href: h.second_step_profile_production_site_order_path(production_site, object)) do
      h.concat(h.content_tag(:p) { 'Далее' })
      h.concat(h.content_tag(:image, src: h.asset_path('svg/thin_arrow_right.svg'), id: 'btn-next') {})
    end
  end

  def count_volume
    number_of_employees + candidates.where(state: [:hired, :approved, :paid]).count
  end

  def difference_volum_and_paided
    count_volume - proposal_employees.paid.count
  end

  def count_hired_in_percent
    result = proposal_employees.paid.count / count_volume.to_f
    result = (result.nan? || result.infinite?) ? 0 : ( result.round(2) * 100 ).to_i
    rescue ZeroDivisionError
      0
  end

  def count_speed_hired(end_period)
    end_period = ( end_period.nil? || end_period.empty?) ? Time.current : Date.parse(end_period)

    be_month = (end_period.year - created_at.year) * 12 + end_period.month - created_at.month + ((end_period.day - created_at.day).positive? ? 1 : 0)
    result = proposal_employees.paid.count / be_month.to_f
    result = (result.nan? || result.infinite?) ? 0 : result.ceil
    rescue ZeroDivisionError
      0
  end

  def published_at
    model.published_at&.strftime('%d.%m.%Y')
  end

  def state_for_selectors
    I18n.t("order.states_for_select.#{model.state}")
  end
end
