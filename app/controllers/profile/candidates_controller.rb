class Profile::CandidatesController < ApplicationController
  def index
    paginated_candidates
  end

  def show
    candidate
  end

  private

  def candidate
    @candidate ||= candidates.find(params[:id]).decorate
  end

  def paginated_candidates
    @paginated_candidates ||= candidates.page(params[:page]).per(10).decorate
  end

  def candidates
    @q = ProposalEmployee.candidates(current_profile).ransack(params[:q])
    @candidates ||= @q.result
  end
end
