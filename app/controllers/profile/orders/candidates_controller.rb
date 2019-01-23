class Profile::Orders::CandidatesController < ApplicationController
  def index
    paginated_candidates
    render partial: 'profile/orders/candidates/index', locals: { items: paginated_candidates }, layout: false
  end

  def hire
    render(plain: 'order completed', status: 422) and return if order.completed?

    if order.selected_candidates.count < order.number_of_employees
      hiring_date = Date.parse(candidate_params[:hiring_date])
      candidate.update(hiring_date: hiring_date,
                       warranty_date: Holiday.warranty_date(hiring_date),
                       order_id: params[:order_id],
                       proposal_id: candidate_params[:proposal_id])
      candidate.hire!
      if order.reload.selected_candidates.count == order.number_of_employees
        order.complete!
      end
      redirect_to profile_order_path(order)
      # else
      #   redirect_to profile_order_proposal_path(order, proposal)
      # end
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
    @candidate ||= EmployeeCv.find(candidate_params[:id])
  end

  def proposal
    @proposal ||= Proposal.find(candidate_params[:proposal_id])
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

  # Меню кандидатов и постраничный вывод
  def states_by_term
    EmployeeCv.customer_menu_items[term]
  end

  def term
    term = params[:term]
    @term = if !term
              :inbox
            elsif term.empty?
              :inbox
            else
              EmployeeCv.customer_menu_items.keys.include?(term.to_sym) ? term.to_sym : :inbox
            end
  end

  def paginated_candidates
    @paginated_candidates ||= scoped_candidates.page(params[:page])
  end

  def scoped_candidates
    @scoped_candidates ||= states_by_term.empty? ? candidates : candidates.where(state: states_by_term)
  end

  def candidates
    @candidates ||= order.proposal_employees
  end
end
