class AppealDecorator < TicketDecorator
  delegate_all

  def header
    "Обращение #{model.id}"
  end

  def close_action_enabled?(_subject)
    model.opened?
  end
end
