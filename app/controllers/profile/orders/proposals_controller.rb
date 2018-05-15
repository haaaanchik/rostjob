class Profile::Orders::ProposalsController < ApplicationController
  def show
    render locals: { proposal: proposal }
  end

  private

  def proposal
    @proposal ||= proposals.find(params[:id])
  end

  def proposals
    @proposals ||= order.proposals
  end

  def order
    @order ||= orders.find(params[:order_id])
  end

  def orders
    @orders ||= current_profile.orders
  end
end
