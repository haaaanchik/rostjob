class Profile::CandidatesController < ApplicationController
  def index
    paginated_candidates
    @active_item = :candidates
  end

  def show
    candidate
    @remained_warranty_days = Holiday.remained_warranty_days(candidate.hiring_date, candidate.warranty_date)
    respond_to do |format|
      format.html
      format.js
      format.pdf { render pdf_setting  }
    end
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
    @result = Cmd::ProposalEmployee::ApproveListActs.call(candidates: candidates, selected_candidates_ids: params[:proposal_employees_ids])
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

  def pdf_setting
    {
      pdf: "ROSTJOB_#{candidate.employee_cv.id}",
      template: 'export_pdf/employee_cv.html',
      orientation: 'Portrait',
      page_size: 'A4',
      show_as_html: params.key?('debug'),
      dpi: 300,
      encoding: 'utf-8'
    }
  end

end
