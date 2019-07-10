class TicketDecorator < ApplicationDecorator
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

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
