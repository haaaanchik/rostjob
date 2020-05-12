class Profile::ProductionSites::Orders::CandidatesController < Profile::ProductionSites::Orders::ApplicationController

  def show
    @pecv = candidate
    @remained_warranty_days = Holiday.remained_warranty_days(@pecv.hiring_date, @pecv.warranty_date)
  end

  def update
    hiring_date = Date.parse(correction_params[:hiring_date])
    candidate.update(hiring_date: hiring_date, warranty_date: Holiday.warranty_date(hiring_date), hiring_date_corrected: true)
    @pecv = candidate
    @remained_warranty_days = Holiday.remained_warranty_days(@pecv.hiring_date, @pecv.warranty_date)
    redirect_to profile_candidate_path(candidate)
  end

  def hire
    render(plain: 'order completed', status: 422) and return if order.completed?

    hiring_date = Date.parse(candidate_params[:hiring_date])
    Cmd::ProposalEmployee::Hire.call(candidate: candidate, hiring_date: hiring_date)
    flash[:redirection] = 'to_hired'
    redirect_to profile_order_path(order)
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

  def hd_correction
    candidate
  end

  def reserve
    candidate.to_reserved!
    redirect_to profile_order_path(order)
  end

  def to_inbox
    result = Cmd::ProposalEmployee::ToInbox.call(candidate: candidate)

    if result.success?
      redirect_to profile_order_path(order)
    end
  end

  def to_interview
    render(plain: 'order completed', status: 422) and return if order.completed?

    result = Cmd::ProposalEmployee::ToInterview.call(candidate: candidate,
                                                     interview_date: candidate_params[:interview_date])
    if result.success?
      flash[:redirection] = 'to_interview'
      redirect_to profile_order_path(order)
    end
  end

  def transfer
    result = Cmd::ProposalEmployee::Transfer.call(candidate: candidate, dst_order_id: transfer_params[:dst_order_id])

    if result.success?
      redirect_to profile_candidate_path(candidate)
    else
      render json: { validate: true, data: errors_data(result.candidate) }, status: 422
    end
  end

  private

  def transfer_params
    params.require(:proposal_employee_decorator).permit(:dst_order_id)
  end

  def contractors
    @contractors ||= order.profiles.map do |profile|
      profile.sent_proposal_employees = profile.sent_proposal_employees_by_order(order).where(state: term)
      profile
    end
  end

  def correction_params
    params.require(:proposal_employee).permit(:id, :hiring_date, :hd_correction_reason)
  end

  def candidate_params
    params.require(:candidate).permit(:id, :interview_date, :hiring_date, :firing_date, :hd_correction_reason, :proposal_id)
  end

  def candidate
    @candidate ||= candidates.find(params[:id]).decorate
  end

  def order
    @order ||= current_profile.orders.find(params[:order_id])
  end

  def term
    term = params[:term]
    @term = if term.blank?
              %w[inbox]
            elsif EmployeeCv.customer_menu_items.include?(term)
              term == 'hired' ? %w[hired paid] : [term]
            elsif term == 'reserved'
              %w[reserved]
            elsif term == 'interview'
              %w[interview]
            elsif term == 'transfer'
              %w[transfer]
            else
              %w[inbox]
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
