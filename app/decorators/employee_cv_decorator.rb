class EmployeeCvDecorator < ApplicationDecorator
  delegate_all

  def employee_cv_id
    model.id
  end
end
