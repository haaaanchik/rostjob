class ProposalEmployeeDecorator < ObjDecorator
  delegate_all

  STATUS_BACKGROUND_COLORS = {
    'inbox' => 'yellow',
    'interview' => 'orange',
    'hired' => 'green',
    'disputed' => 'red',
    'paid' => 'grey',
    'deleted' => 'brown',
    'reserved' => 'blue',
    'transfer' => 'default-color'
  }

  STATUS_BACKGROUND_COLORS.default = 'blue'

  STATUS_ICON_COLORS = {
    inbox: '#ffd800',
    interview: '#ff9000',
    hired: '#00ca5f',
    paid: '#b7b7b7'
  }

  ACTIONS = {
    'customer' => {
      'inbox' => %w[revoked interview transfer],
      'reserved' => %w[inbox interview transfer],
      'interview' => %w[hired disputed transfer],
      'hired' => %w[disputed],
      'disputed' => %w[disputed]
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

  def link_to_candidate_or_ticket
    object.disputed? ? ticket_path : order_path
  end

  def ticket_path
    tickets = Ticket.with_other_tickets_for(h.current_user).ransack(state_cont: 'opened').result
    ticket = tickets.find_by(proposal_employee_id: id)
    ticket ? h.profile_ticket_path(ticket) : h.profile_tickets_path
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
    if object.inbox?
      h.to_interview_profile_order_candidate_path(object.order_id, object)
    elsif object.interview?
      h.hire_profile_order_candidate_path(object.order_id, object)
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
    ACTIONS[subject.subject_type][model.state]&.include?('disputed')
  end

  def transfer_action_enabled?(subject)
    ACTIONS[subject.subject_type][model.state]&.include?('transfer')
  end

  def approve_transfer_action_enabled?(subject)
    ACTIONS[subject.subject_type][model.state]&.include?('approve')
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
    if object.interview?
      name = 'hiring_date'
      text = 'Нанять'
    elsif object.inbox?
      name = 'interview_date'
      text = 'Назначить'
    end
    { name: name, text: text }
  end

  def format_date(date)
    date.strftime('%d.%m.%Y')
  end
end
