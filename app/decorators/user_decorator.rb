class UserDecorator < ObjDecorator
  delegate_all

  def orders_count
    model.profile.orders.count
  end

  def employee_cvs_count
    model.profile.employee_cvs.count
  end

  def disputs_count
    0
  end
end
