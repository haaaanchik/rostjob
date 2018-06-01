class Profile::ProposalsController < ApplicationController
  def index
    sent_proposals
  end

  def show
    render locals: { proposal: proposal }
  end

  def create
    result = find_or_create_proposal(proposal_params)
    if result.valid?
      redirect_to orders_path
    else
      render json: result.errors.messages
    end
  end

  def send_message
    msg = proposal.messages.create(message_params)
    if msg.persisted?
      message = render_to_string partial: 'shared/messages/message', object: msg, locals: { to_receiver: true }, layout: false
      ActionCable.server.broadcast("chat_channel_#{msg.receiver}", message)
      render partial: 'shared/messages/message', object: msg, layout: false
    else
      render json: msg.errors.messages, status: 422
    end
  end

  def cancel
    proposal.cancel!
    redirect_to profile_proposals_path
  end

  private

  def find_or_create_proposal(proposal_params)
    prop = proposals.find_by(order_id: proposal_params[:order_id])
    if prop
      prop.resend!
      return prop
    end
    proposals.create(proposal_params)
  end

  def message_params
    params.require(:message).permit(:text).merge(sender_id: current_profile.id)
  end

  def proposal_params
    p = params.require(:proposal).permit(:description, :order_id, :profile_id, :accepted,
                                         messages_attributes: [:text],
                                         employee_cvs_attributes: %i[name gender birthdate file])
    p[:messages_attributes]['0'][:sender_id] = current_profile.id
    p
  end

  def proposal
    @proposal ||= proposals.find(params[:id])
  end

  def proposals
    @proposals ||= current_profile.proposals
  end

  def sent_proposals
    @proposals ||= current_profile.proposals.sent
  end
end
