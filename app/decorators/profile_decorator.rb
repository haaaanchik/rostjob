class ProfileDecorator < ObjDecorator
  delegate_all

  def order_cities
    orders.published.map(&:city).uniq.join(', ')
  end

  def order_titles
    orders.published.map(&:title).uniq.join(', ')
  end
end
