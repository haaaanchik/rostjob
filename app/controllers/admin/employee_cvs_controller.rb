# frozen_string_literal: true

class Admin::EmployeeCvsController < Admin::ApplicationController
  before_action :set_authorize
  before_action :set_employee_cvs

  def edit; end

  def update
    if @employee_cv.update(employee_cv_params)
      flash[:notice] = "Анкета #{@employee_cv.name} обновлена"
    else
      flash[:alert] = "Не удалось обновить анкету #{@employee_cv.name}"
    end

    redirect_to admin_proposal_employees_path
  end

  private

  def set_employee_cvs
    @employee_cv = EmployeeCv.find(params[:id])
  end

  def employee_cv_params
    params.require(:employee_cv).permit(:name, :phone_number, :gender,
                                        :experience, :education, :remark)
  end

  def set_authorize
    authorize [:admin, :employee_cv]
  end
end
