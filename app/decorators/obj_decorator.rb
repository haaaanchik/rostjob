class ObjDecorator < ApplicationDecorator
  delegate_all

  def order_id; end

  def employee_cv_id; end
end
