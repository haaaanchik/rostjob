class OrdersController < ApplicationController
  def index
    @order_search_form = OrderSearchForm.new(order_search_form_params)
    @orders = @order_search_form.submit
  end

  def show
    new_proposal = Proposal.new
    new_proposal.employee_cvs.build
    render locals: { order: order, new_proposal: new_proposal }
  end

  private

  def order
    @order = Order.find(params[:id])
  end

  def order_search_form_params
    params.permit(order_search_form: [:query, :sort_by, :filter_by])[:order_search_form]
  end
end
