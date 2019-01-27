class OrderDecorator < ObjDecorator
  delegate_all

  def order_id
    model.id
  end
end
