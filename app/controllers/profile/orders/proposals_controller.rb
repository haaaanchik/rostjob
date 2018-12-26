class Profile::Orders::ProposalsController < ApplicationController
  def show
    render locals: { proposal: proposal }
  end

  def send_message
    msg = proposal.messages.create(message_params)
    if msg.persisted?
      render partial: 'shared/messages/message', object: msg, layout: false
      message = render_to_string partial: 'shared/messages/message', object: msg, locals: { to_receiver: true }, layout: false
      ActionCable.server.broadcast("chat_channel_#{msg.receiver}", message)
    else
      render json: msg.errors.messages, status: 422
    end
  end

  private

  def message_params
    params.require(:message).permit(:text).merge(sender_id: current_profile.id)
  end

  def proposal
    @proposal ||= Proposal.find_by id: params[:id]
  end

  def proposals
    @proposals ||= order.proposals
  end

  def order
    @order ||= Order.find_by id: params[:order_id]
  end

  def orders
    @orders ||= current_profile.orders
  end
end
