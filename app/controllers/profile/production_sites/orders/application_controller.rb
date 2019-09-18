class Profile::ProductionSites::Orders::ApplicationController < Profile::ProductionSites::ApplicationController
  private

  def order
    @order ||= orders.find(params[:order_id])
  end

  def orders
    @orders ||= production_site.orders
  end
end
