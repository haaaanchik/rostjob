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

  def approval_list
    @approval_list = candidates.includes(:employee_cv, order: :production_site)
                         .approved
                         .page(params[:page]).per(10)
    @active_item = :approve_act_list
  end

  private

  def candidate
    @candidate ||= ProposalEmployee.candidates(current_profile).find(params[:id]).decorate
  end

  def paginated_candidates
    @paginated_candidates ||= candidates.page(params[:page]).per(10).decorate
  end

  def candidates
    @q = ProposalEmployee.candidates(current_profile).ransack(params[:q])
    @candidates ||= @q.result
  end
end
