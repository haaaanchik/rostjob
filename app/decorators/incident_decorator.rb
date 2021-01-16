class IncidentDecorator < TicketDecorator
  delegate_all

  ACTIONS = {
    'other' => {
      'customer' => %w[],
      'contractor' => %w[],
      'staffer' => %w[revoke to_inbox hire to_interview]
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

  def to_interview_action_enabled?(subject)
    ACTIONS[model.reason][subject.subject_type]&.include?('to_interview')
  end

  def header
    "Спорная анкета №#{employee_cv.id} #{employee_cv.name}<br>Заявка №#{order.id} #{order.title}".html_safe
  end

  def revoced_by_customer?
    messages.where('text like ?', '%Кандидату отказано в трудоустройстве или договор разорван на основании(ях):%').present?
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
