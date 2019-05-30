class ProposalEmployeeDecorator < ObjDecorator
  delegate_all

  STATUS_BACKGROUND_COLORS = {
    'inbox' => 'yellow',
    'interview' => 'orange',
    'hired' => 'green',
    'disputed' => 'red',
    'paid' => 'grey',
    'deleted' => 'brown',
    'reserved' => 'blue'
  }

  STATUS_BACKGROUND_COLORS.default = 'blue'

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

  def interview_action_enabled?(subject)
    subject.customer? ? %w[inbox reserved].include?(model.state) : nil
  end

  def hire_action_enabled?(subject)
    subject.customer? ? %w[interview].include?(model.state) : nil
  end

  def reserve_action_enabled?(subject)
    subject.customer? ? %w[inbox interview disputed].include?(model.state) : nil
  end

  def revoke_action_enabled?(subject)
    subject.contractor? ? %w[inbox].include?(model.state) : nil
  end

  def to_inbox_action_enabled?(subject)
    subject.customer? ? %w[reserve].include?(model.state) : nil
  end

  def disput_action_enabled?(subject)
    if subject.customer?
      %w[inbox interview hired disputed].include?(model.state)
    elsif subject.contractor?
      %w[inbox interview hired disputed].include?(model.state)
    end
  end
end
