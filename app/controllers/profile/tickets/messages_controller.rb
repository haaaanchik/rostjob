class Profile::Tickets::MessagesController < ApplicationController
  def index
    messages
  end

  def create
    result = Cmd::Ticket::Message::Create.call(user: current_user,
                                               ticket: ticket,
                                               message_params: message_params)
    if result.success?
      @status = 'success'
      @message = result.message.decorate
    else
      render json: { validate: true, data: errors_data(result.message) }, status: 422
    end
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end

  def ticket
    @ticket ||= tickets.find(params[:ticket_id])
  end

  def tickets
    @tickets ||= Ticket.with_other_tickets_for(current_user)
  end
end
