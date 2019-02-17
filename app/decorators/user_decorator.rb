class UserDecorator < ObjDecorator
  delegate_all

  def orders_count
    model.orders_count ? model.orders_count : 0
  end

  def employee_cvs_count
    model.employee_cvs_count ? model.employee_cvs_count : 0
  end

  def disputs_count
    0
  end
end
