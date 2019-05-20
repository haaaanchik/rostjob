class Profile::CandidatesController < ApplicationController
  def index
    paginated_candidates
    @active_item = :candidates
  end

  def show
    candidate
    @remained_warranty_days = Holiday.remained_warranty_days(candidate.hiring_date, candidate.warranty_date)
  end

  private

  def candidate
    @candidate ||= ProposalEmployee.candidates(current_profile).find(params[:id]).decorate
  end

  def paginated_candidates
    @paginated_candidates ||= candidates.page(params[:page]).per(10).decorate
  end

  def candidates
    @q = ProposalEmployee.candidates(current_profile).ransack(params[:q] ? params[:q] : { state_in: %w[hired disputed] })
    @candidates ||= @q.result
  end
end
