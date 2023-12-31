class OrderDecorator < ApplicationDecorator
  delegate_all

  def link_profile_list(params)
    if count_pr_employees_state(params).zero?
      count_pr_employees_state(params)
    else
      h.link_to count_pr_employees_state(params), h.admin_proposal_employees_path(q: { state_in: params })
    end
  end

  def order_id
    model.id
  end

  def city_name
    model&.city&.name
  end

  def display_info_price
    return customer_price.to_i if h.current_profile.customer?

    contractor_price.to_i
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

  def display_order_disputed
    return unless candidates.disputed.present?
    return link_to_disputed if candidates.disputed.count == 1

    h.content_tag(:a,
                  href: h.profile_tickets_path(q: { search_by_order_eq: id,
                                                    state_eq: 'opened' }),
                  class:'red-text') {"+ #{ candidates.disputed.count} спор(ов)"}

  end

  def total_price
    return customer_total if number_additional_employees.nil?
    number_additional_employees.to_i * customer_price
  end

  def replenish_balance?
    return can_be_paid? if number_additional_employees.nil?
    employees_can_be_paid?
  end

  def link_button(proposal)
    case
    when employees_can_be_paid? && proposal[:canidate_id].present?
      url = if proposal[:incident_id].present?
              h.hire_profile_tickets_incident_path(proposal[:incident_id], hiring_date: proposal[:hiring_date])
            else
              h.hire_in_compleated_order_profile_order_candidate_path(object, proposal[:canidate_id], 
                                                                      candidate: {hiring_date: proposal[:hiring_date]})
            end

      h.content_tag(:a,
                    href: url,
                    class: 'public',
                    data: { method: :put }) { 'Оплатить и нанять' }
    when employees_can_be_paid?
      h.content_tag(:a,
                    href: h.add_additional_employees_profile_production_site_order_path(production_site, object),
                    class: 'public',
                    data: { method: :put }) { 'Оплатить' }
    when !replenish_balance?
      h.content_tag(:a,
                    id: 'up_balance',
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

  def difference_volum_and_paided(paid_candidates)
    number_of_employees - paid_candidates
  end

  def count_hired_in_percent(paid_candidates)
    return 0 if number_of_employees.zero?

    paid_candidates / number_of_employees * 100
  end

  def count_speed_hired(size_paid_candidates)
    return 0 if count_month_is_be.zero?

    (size_paid_candidates / count_month_is_be).ceil
  end

  def formated_date(column)
    model.send(column)&.strftime('%d.%m.%Y')
  end

  def state_for_analytics
    I18n.t("order.states_for_select.#{model.state}")
  end

  def actuality_for_analytics
    I18n.t("order.actuality.#{model.actual.to_s}")
  end

  def count_pr_employees_state(state)
    count_states ||= proposal_employees.group(:state).count
    count_states[state] || 0
  end

  def show_added_data
    'Отправьте анкету с заполненными: ' + other_info['requirements']['added_data']['text'] + ' (анкеты без всех данных будут отклонены!)'
  end

  def show_requirements
    return unless other_info['requirements']

    h.content_tag(:ol) do
      model.other_info['requirements'].each do |key, value_hash|
        next unless value_hash['show'] == '1'

        text = key == 'added_data' ? show_added_data : value_hash['text']

        h.concat h.content_tag(:li, text)
      end
    end
  end

  def last_pr_empl
    proposal_employees&.last&.created_at&.strftime('%d.%m.%Y')
  end

  def order_zp_city
    response = ZarplataRu::Search.city(city)
    return [] if response['geo'].blank?

    response['geo'].collect { |geo| {id: geo['id'],
                                      name: geo['name']}}
  end

  def remove_link(hash_values)
    candidates_in_orderd = hash_values[:candidate_countes][hash_values[:favorite].id]
    return unless candidates_in_orderd.to_i.zero?

    h.link_to('Убрать', h.remove_from_favorites_order_path(hash_values[:favorite]),
                method: :put,
                remote: true,
                class: 'dropdown-item')
  end

  def disabled_profession?
    return true if published? || completed?

    false
  end

  def should_have_new_label?
    return false if published_at_original.nil?
    published_at_original > Date.today - 1.week
  end

  private

  def link_to_disputed
    incident = candidates.disputed.first.incidents.first

    h.link_to "+ #{ candidates.disputed.count} спор(ов)",
              h.profile_ticket_path(incident),
              class:'red-text'
  end

  def count_month_is_be
    start_periond = published_at || created_at
    end_perion = completed_at || Date.today

    ((end_perion.to_date - start_periond.to_date).to_f / 365 * 12).round
  end
end
