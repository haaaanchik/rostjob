class RecruitersController < ApplicationController
  def index
    @recruiter_search_form = RecruiterSearchForm.new(recruiter_search_form_params)
    @recruiters = @recruiter_search_form.submit
  end

  def show
    render locals: { recruiter: recruiter }
  end

  private

  def recruiter
    @recruiter = Profile.find(params[:id])
  end

  def recruiter_search_form_params
    params.permit(recruiter_search_form: [:query])[:recruiter_search_form]
  end
end
