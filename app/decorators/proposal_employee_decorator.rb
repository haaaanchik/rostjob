class ProposalEmployeeDecorator < ObjDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def order_id
    model.order_id
  end

  def employee_cv_id
    model.employee_cv_id
  end

  def date
    model.created_at.strftime('%d.%m.%Y')
  end

  def time
    model.created_at.strftime('%H:%M')
  end
end
