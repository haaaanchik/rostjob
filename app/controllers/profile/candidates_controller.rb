class Profile::CandidatesController < ApplicationController
  def index
    paginated_candidates
    @active_item = :candidates
  end

  def show
    candidate
    @remained_warranty_days = Holiday.remained_warranty_days(candidate.hiring_date, candidate.warranty_date)
  end

  # FIXME: refactor this asap
  def revoke
    result = Cmd::ProposalEmployee::Revoke.call(proposal_employee: candidate, log: true)
    result.success? ? (redirect_to profile_candidates_path) :
                      (render json: { validate: true,
                                      data:     errors_data(result.proposal_employee) },
                              status: 422)
  end

  def approve_act
    @result = Cmd::ProposalEmployee::Pay.call(candidate: candidate)
  end

  def approve_all_acts
    @result = Cmd::ProposalEmployee::ApproveListActs.call(candidates: candidates, profile_id: params[:profile_id])
  end

  def approval_list
    @paginated_lists = candidates.includes(:employee_cv, :profile, order: :production_site)
                           .approved
                           .order(:profile_id)
                           .page(params[:page]).per(10)
    @approval_list = @paginated_lists.group_by { |pr_empl| pr_empl.profile.decorate }
    @active_item = :approve_act_list
  end

  private

  def candidate
    @candidate ||= ProposalEmployee.candidates(current_profile).find(params[:id]).decorate
  end

  def paginated_candidates
    @paginated_candidates ||= candidates.page(params[:page]).per(10).includes(order: :production_site).decorate
  end

  def candidates
    @q = ProposalEmployee.candidates(current_profile).ransack(params[:q])
    @candidates ||= @q.result
  end
end
