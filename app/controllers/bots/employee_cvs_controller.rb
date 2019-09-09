class Bots::EmployeeCvsController < ApplicationController
  def show
    employee_cv
  end

  private

  def employee_cv
    @employee_cv ||= bot_profile.employee_cvs.find(params[:id])
  end

  def bot_profile
    @bot_profile ||= bot_user.profile
  end

  def bot_user
    @bot_user ||= User.find_by(email: 'bot@best-hr.pro')
  end
end
