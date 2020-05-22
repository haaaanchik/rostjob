module Profile::OrdersHelper
  def orders_group_by_profile(orders)
    orders.group_by(&:profile)
  end

  def orders_paginate(orders)
    orders.page(params[:page])
  end
end
