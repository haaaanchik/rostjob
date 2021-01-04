class Admin::Tickets::MessagesController < Admin::Tickets::ApplicationController
  def index
    messages
  end

  def create
    result = Cmd::Ticket::Message::Create.call(user: current_staffer.decorate,
                                               message_params: message_params,
                                               ticket: ticket)
    if result.success?
      render partial: 'admin/tickets/messages/message', object: result.message, layout: false
    else
      render json: { validate: true, data: errors_data(result.message) }, status: 422
    end
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end
end
