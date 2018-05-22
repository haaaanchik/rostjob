class Profile::ProposalsController < ApplicationController
  def index
    proposals
  end

  def show
    render locals: { proposal: proposal }
  end

  def new
    @proposal = Proposal.new
  end

  def edit
    proposal
  end

  def create
    result = proposals.create(proposal_params)
    if result.valid?
      redirect_to orders_path
    else
      render json: result.errors.messages
    end
  end

  def update
    proposal.update(proposal_params)
  end

  def destroy
    proposal.destroy
    redirect_to profile_proposals_path
  end

  def publish
    proposal.activate!
    redirect_to profile_proposals_path
  end

  def complete
    proposal.complete!
    redirect_to profile_proposals_path
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

  private

  def message_params
    params.require(:message).permit(:text).merge(sender_id: current_profile.id)
  end

  def proposal_params
    params.require(:proposal).permit(:description, :order_id, :profile_id, :accepted,
                                     messages_attributes: [:text],
                                     employee_cvs_attributes: [:name, :gender, :birthdate, :file])
  end

  def proposal
    @proposal ||= proposals.find(params[:id])
  end

  def proposals
    @proposals ||= if params[:state] && !params[:state].empty?
                     current_profile.proposals.where state: params[:state]
                   else
                     current_profile.proposals
                   end
  end
end
