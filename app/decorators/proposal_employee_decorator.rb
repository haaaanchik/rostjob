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

  def ticket_path
    tickets = Ticket.with_other_tickets_for(h.current_user).ransack(state_cont: 'opened').result
    ticket = tickets.find_by(proposal_employee_id: id)
    ticket ? h.profile_ticket_path(ticket) : h.profile_tickets_path
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
end
