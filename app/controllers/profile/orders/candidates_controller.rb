class Profile::Orders::CandidatesController < ApplicationController
  def index
    render partial: 'profile/orders/contractors/contractor_card', collection: contractors, layout: false
  end

  def show
    @pecv = candidate
    @remained_warranty_days = Holiday.remained_warranty_days(@pecv.hiring_date, @pecv.warranty_date)
  end

  def hire
    render(plain: 'order completed', status: 422) and return if order.completed?

    if order.selected_candidates.count < order.number_of_employees
      hiring_date = Date.parse(candidate_params[:hiring_date])
      candidate.update(hiring_date: hiring_date, warranty_date: Holiday.warranty_date(hiring_date))
      candidate.employee_cv.update(order_id: params[:order_id],
                                   proposal_id: candidate_params[:proposal_id])
      Cmd::ProposalEmployee::Hire.call(candidate: candidate)
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

    candidate.employee_cv.update(firing_date: candidate_params[:firing_date])
    candidate.fire!

    redirect_to profile_order_path(order)
  end

  def destroy
    candidate.to_deleted!
    redirect_to profile_order_path(order)
  end

  def disput
    candidate.to_disputed!
    redirect_to profile_order_path(order)
  end

  private

  def contractors
    @contractors ||= order.profiles.map do |profile|
      profile.sent_proposal_employees = profile.sent_proposal_employees_by_order(order).where(state: term)
      profile
    end
  end

  def candidate_params
    params.require(:candidate).permit(:id, :hiring_date, :firing_date, :proposal_id)
  end

  def candidate
    @candidate ||= candidates.find(params[:id])
    # @candidate ||= EmployeeCv.find(candidate_params[:id])
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
              'inbox'
            elsif term.empty?
              'inbox'
            else
              EmployeeCv.customer_menu_items.include?(term) ? term : 'inbox'
            end
  end

  def paginated_candidates
    @paginated_candidates ||= scoped_candidates.page(params[:page])
  end

  def scoped_candidates
    @scoped_candidates ||= candidates.where(state: term)
  end

  def candidates
    @candidates ||= order.proposal_employees
  end
end
