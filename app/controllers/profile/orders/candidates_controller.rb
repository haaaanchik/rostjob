class Profile::Orders::CandidatesController < ApplicationController
  def hire
    render(plain: 'order completed', status: 422) and return if order.completed?

    if order.selected_candidates.count < order.number_of_employees
      candidate.update(hiring_date: candidate_params[:hiring_date], order_id: params[:order_id])
      candidate.hire!
      if order.reload.selected_candidates.count == order.number_of_employees
        order.complete!
        redirect_to profile_order_path(order)
      else
        redirect_to profile_order_proposal_path(order, proposal)
      end
    else
      render plain: 'all employees has been hired', status: 422
    end
  end

  def fire
    render(plain: 'candidate already fired', status: 422) and return if candidate.fired?

    candidate.update(firing_date: candidate_params[:firing_date])
    candidate.fire!

    redirect_to profile_order_path(order)
  end

  private

  def candidate_params
    params.require(:candidate).permit(:id, :hiring_date, :firing_date, :proposal_id)
  end

  def candidate
    @candidate ||= proposal.employee_cvs.find(candidate_params[:id])
  end

  def proposal
    @proposal ||= proposals.find(candidate_params[:proposal_id])
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
