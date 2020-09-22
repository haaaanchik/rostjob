class TicketMailer < ApplicationMailer
  def notify_user(message)
    @message = message
    email = message.ticket.user.email

    mail(to: email, subject: "Ответ на обращение ##{message.ticket_id}")
  end
end
