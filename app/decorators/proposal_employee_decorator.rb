class ProposalEmployeeDecorator < ApplicationDecorator
  delegate_all

  STATUS_BACKGROUND_COLORS = {
    'inbox' => 'yellow',
    'interview' => 'orange',
    'hired' => 'green',
    'disputed' => 'red',
    'paid' => 'dark',
    'deleted' => 'brown',
    'reserved' => 'blue',
    'approved' => 'grey',
    'transfer' => 'default-color'
  }

  STATUS_BACKGROUND_COLORS.default = 'blue'

  STATUS_ICON_COLORS = {
    inbox: '#ffd800',
    interview: '#ff9000',
    hired: '#00ca5f',
    approved: '#b7b7b7',
    paid: '#b7b7b7'
  }

  ACTIONS = {
    'customer' => {
      'inbox' => %w[revoked interview transfer],
      'reserved' => %w[inbox interview transfer],
      'interview' => %w[hired disputed transfer],
      'hired' => %w[disputed],
      'disputed' => %w[disputed],
      'approved' => %w[disputed]
    },
    'contractor' => {
      'inbox' => %w[revoked disputed],
      'interview' => %w[revoked disputed],
      'reserved' => %w[revoked],
      'hired' => %w[disputed],
      'disputed' => %w[disputed],
      'transfer' => %w[approve]
    },
    'staffer' => {
      'disputed' => %w[inbox interview hired reserved]
    }
  }.freeze

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def name
    model.employee_cv.name
  end

  def employee_id_name
    "№#{employee_cv.id} #{employee_cv.name}"
  end

  def title
    model.order.title
  end

  def place_of_work
    model.order.place_of_work
  end

  def order_id
    model.order_id
  end

  def employee_cv_id
    model.employee_cv_id
  end

  def date
    model.last_complaint_time.in_time_zone.strftime('%d.%m.%Y')
  end

  def time
    model.last_complaint_time.in_time_zone.strftime('%H:%M')
  end

  def status_background_class
    STATUS_BACKGROUND_COLORS[model.state]
  end

  def status_color_class
    STATUS_ICON_COLORS[object.state.to_sym]
  end

  def ticket_path
    tickets = Ticket.with_other_tickets_for(h.current_user).ransack(state_cont: 'opened').result
    ticket = tickets.find_by(proposal_employee_id: id)
    ticket ? h.profile_ticket_path(ticket) : h.profile_tickets_path
  end

  def contractor_calendar_title
    case state
    when 'inbox', 'interview'
      'Дата приезда'
    when 'hired'
      'Дата выхода на работу'
    else
      ''
    end
  end

  def contractor_calendar_text(warranty_days)
    text = ''
    klass = nil
    hired_text = ''
    case state
    when 'paid', 'viewed'
      text = h.t("proposal_employee.state.#{state}")
      klass = 'text-success'
    when 'hired'
      text = h.t("proposal_employee.state.hired")
      klass = 'text-success'
      hired_text = ". Осталось #{h.t(:day, count: warranty_days.size)}."
    when 'deleted', 'disputed'
      text = h.t("proposal_employee.state.#{state}")
      klass = 'text-danger'
    when 'inbox'
      text = h.t("proposal_employee.state.inbox")
      klass = 'text-warning'
    else
      ''
    end
    h.content_tag(:span, class: "text-center #{klass}") { text + hired_text }
  end

  def calendar_title
    case object.state
    when 'interview'
      'Дата выхода на работу'
    when 'inbox'
      'Дата собеседования'
    when 'hired'
      'Гарантийный период'
    else
      nil
    end
  end

  def calendar_form_url
    case state
    when 'interview'
      h.hire_profile_order_candidate_path(order_id, object)
    when 'inbox'
      h.to_interview_profile_order_candidate_path(order_id, object)
    when 'hired'
      h.to_approved_profile_order_candidate_path(order_id, object)
    else
      nil
    end
  end

  def calendar_hidden_field(value)
    attr = interview_or_inbox
    h.content_tag(:input,
                  type: 'hidden',
                  name: "candidate[#{attr[:name]}]",
                  value: value,
                  id: "candidate_#{attr[:name]}"){} if attr[:name].present?
  end

  def calendar_submit
    attr = interview_or_inbox

    h.content_tag(:input,
                  type: 'submit',
                  name: 'commit',
                  value: attr[:text],
                  data: { 'disable-with': attr[:text] },
                  id: 'get-recruter'){} if attr[:text].present?
  end

  def display_date_to_card
    return format_date(interview_date) if ['inbox', 'interview'].include? state
    format_date(hiring_date)
  end

  def display_candidate_date
    date =  hiring_date.present? ? hiring_date : interview_date
    date.strftime('%d.%m.%Y')
  end

  def calendar_format_date
    interview_date.strftime('%Y-%m-%d')
  end

  def interview_action_enabled?(subject)
    ACTIONS[subject.subject_type][model.state]&.include?('interview')
  end

  def hire_action_enabled?(subject)
    ACTIONS[subject.subject_type][model.state]&.include?('hire')
  end

  def reserve_action_enabled?(subject)
    ACTIONS[subject.subject_type][model.state]&.include?('reserved')
  end

  def revoke_action_enabled?(subject)
    ACTIONS[subject.subject_type][model.state]&.include?('revoked')
  end

  def to_inbox_action_enabled?(subject)
    ACTIONS[subject.subject_type][model.state]&.include?('inbox')
  end

  def disput_action_enabled?(subject)
    ACTIONS[subject.subject_type][model.state]&.include?('disputed') && !model.disputed?
  end

  def transfer_action_enabled?(subject)
    ACTIONS[subject.subject_type][model.state]&.include?('transfer')
  end

  def approve_transfer_action_enabled?(subject)
    ACTIONS[subject.subject_type][model.state]&.include?('approve')
  end

  def sex
    model.employee_cv.gender == 'М' ? 'Мужской' : 'Женский'
  end

  def display_pr_site_or_interview_date(user)
    return order.production_site.title if user.profile.customer?

    interview_date.strftime('%d.%m.%Y')
  end

  def candidate_phone_number(user)
    return model.phone_number if user.profile.customer?

    employee_cv.phone_number
  end

  def link_to_candidate(user)
    return link_to_candidate_or_ticket if user.profile.customer?

    disputed? ? h.profile_ticket_path(incidents.opened.last) : h.profile_employee_cvs_path(proposal_employee_id: id)
  end

  def display_candidate_date_for_customer(user)
    return if user.profile.customer?

    h.content_tag(:span, "с #{display_candidate_date}", class: 'date')
  end

  def display_comment(user)
    return comment if user.profile.customer?

    employee_cv.comment
  end

  def link_to_show(user)
    url = revoked? ? '#' : url_to_show(user)

    h.content_tag :a, href: url, 'data-remote' => true do
      h.content_tag(:p, "№ #{employee_cv.id} #{employee_cv.name}", class: 'request__title')
    end
  end

  private

  def order_path
    h.profile_production_site_order_path(order.production_site,
                                         order,
                                         proposal_employee_id: id)
  end

  def interview_or_inbox
    name = nil
    text = nil
    case state
    when 'interview'
      name = 'hiring_date'
      text = 'Нанять'
    when 'inbox'
      name = 'interview_date'
      text = 'Назначить'
    when 'hired'
      text = 'Подтвердить гарантию'
    else
      nil
    end
    { name: name, text: text }
  end

  def format_date(date)
    date.strftime('%d.%m.%Y')
  end

  def link_to_candidate_or_ticket
    object.disputed? ? ticket_path : order_path
  end

  def url_to_show(user)
    return h.profile_candidate_path(model) if user.profile.customer?

    h.profile_proposal_employee_path(model)
  end
end
