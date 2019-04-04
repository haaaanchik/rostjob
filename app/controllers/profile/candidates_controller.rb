class Profile::CandidatesController < ApplicationController
  def index
    paginated_candidates
  end

  private

  def paginated_candidates
    @paginated_candidates ||= candidates.page(params[:page]).per(10).decorate
  end

  def candidates
    @q = ProposalEmployee.candidates(current_profile).ransack(params[:q])
    @candidates ||= @q.result
  end
end
