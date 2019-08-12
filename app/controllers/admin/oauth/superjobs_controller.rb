class Admin::Oauth::SuperjobsController < Admin::Oauth::ApplicationController
  def show; end

  def edit
    super_job
  end

  def update
    super_job.update(super_job_params)
  end

  def employee_cvs
    respond_to do |format|
      format.xlsx do
        result = Cmd::SuperJob::Resumes::Download.call(params: ecv_params)
        @employee_cvs = result.employee_cvs
        render xlsx: 'employee_cvs', filename: 'employee_cvs.xlsx'
      end
      format.html
    end
  end

  private

  def super_job_params
    params.require(:super_job).permit(query_params: [:period,
                                                     :experience,
                                                     :moveable,
                                                     :exclude_words,
                                                     :payment_from,
                                                     :payment_to,
                                                     keywords: %i[keys srws skwc]])
  end

  def ecv_params
    params.permit(:date_from, :date_to)
  end

  def super_job
    @super_job ||= SuperJob.config
  end
end
