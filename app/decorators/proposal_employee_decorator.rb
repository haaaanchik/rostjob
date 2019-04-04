class ProposalEmployeeDecorator < ObjDecorator
  delegate_all

  STATUS_BACKGROUND_COLORS = {
    'hired' => 'green',
    'inbox' => 'blue',
    'disputed' => 'red',
    'paid' => 'grey'
  }

  STATUS_BACKGROUND_COLORS.default = 'blue'

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def order_id
    model.order_id
  end

  def employee_cv_id
    model.employee_cv_id
  end

  def date
    model.created_at.strftime('%d.%m.%Y')
  end

  def time
    model.created_at.strftime('%H:%M')
  end

  def status_background_class
    STATUS_BACKGROUND_COLORS[model.state]
  end

  def hire_link_enabled?
    %w[inbox].include?(model.state)
  end

  def info_link_enabled?
    %w[hired].include?(model.state)
  end

  def disput_link_enabled?
    %w[inbox hired disputed].include?(model.state)
  end
end
