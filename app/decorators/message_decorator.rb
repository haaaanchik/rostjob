class MessageDecorator < ApplicationDecorator
  delegate_all

  def message_ctreated_at
    model.created_at.strftime('%d.%m.%Y')
  end
end