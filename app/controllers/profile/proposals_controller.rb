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
    proposals.create(proposal_params)
    redirect_to orders_path
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

  private

  def proposal_params
    params.require(:proposal).permit(:description, :order_id, :profile_id)
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
