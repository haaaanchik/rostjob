class IncidentDecorator < TicketDecorator
  delegate_all

  ACTIONS = {
    'other' => {
      'customer' => %w[],
      'contractor' => %w[],
      'staffer' => %w[revoke to_inbox hire]
    },
    'not_come' => {
      'customer' => %w[],
      'contractor' => %w[],
      'staffer' => %w[]
    }
  }.freeze

  def hire_action_enabled?(subject)
    ACTIONS[model.reason][subject.subject_type]&.include?('hire')
  end

  def revoke_action_enabled?(subject)
    ACTIONS[model.reason][subject.subject_type]&.include?('revoke')
  end

  def to_inbox_action_enabled?(subject)
    ACTIONS[model.reason][subject.subject_type]&.include?('to_inbox')
  end

  def header
    "Спорная анкета №#{employee_cv.id} #{employee_cv.name}<br>Заявка №#{order.id} #{order.title}".html_safe
  end

  private

  def order
    candidate.order
  end

  def employee_cv
    candidate.employee_cv
  end

  def candidate
    model.proposal_employee
  end
end
