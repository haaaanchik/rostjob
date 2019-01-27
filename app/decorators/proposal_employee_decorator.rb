class ProposalEmployeeDecorator < ObjDecorator
  delegate_all

  def order_id
    model.order_id
  end

  def employee_cv_id
    model.employee_cv_id
  end
end
