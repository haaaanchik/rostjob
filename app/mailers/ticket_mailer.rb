class TicketMailer < ApplicationMailer
  def notify_user(message)
    @message = message
    email = message.ticket.user.email

    mail(to: email, subject: "RostJob. Ответ на обращение ##{message.ticket_id}.")
  end

  def new_message
    @ticket = params[:ticket]
    @message = params[:message]
    @user = params[:user]

    mail(to: @user.email, subject: 'RostJob. Поступило новое сообщение.')
  end
end
