class OrdersController < ApplicationController
  def index
    @order_search_form = OrderSearchForm.new(order_search_form_params)
    @orders = @order_search_form.submit
  end

  private

  def order_search_form_params
    params.permit(order_search_form: [:query, :sort_by, :filter_by])[:order_search_form]
  end
end
