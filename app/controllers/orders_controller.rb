class OrdersController < ApplicationController
  before_action :order, except: :index

  def index
    @active_item = :orders
    employee_cv_id
    # @order_search_form = if @employee_cv_id
    #                        osf_params = order_search_form_params.merge(profile: current_profile)
    #                        OrderSearchForm2.new(osf_params)
    #                      else
    #                        OrderSearchForm.new(order_search_form_params)
    #                      end
    orders.decorate
  end

  def show
    render locals: { order: @order }
  end

  def add_to_favorites
    @employee_cv_id = params[:employee_cv_id]
    Cmd::Order::AddToFavorites.call(order: order, profile: current_profile)
  end

  def remove_from_favorites
    @employee_cv_id = params[:employee_cv_id]
    Cmd::Order::RemoveFromFavorites.call(order: order, profile: current_profile)
  end

  private

  def order
    @order = Order.with_customer_name.find(params[:id]).decorate
  end

  def orders
    @q = Order.published.with_customer_name.order(advertising: :desc).ransack(params[:q])
    @orders ||= @q.result
  end

  def employee_cv_id
    @employee_cv_id = params[:employee_cv_id] || params[:q].try(:[], :employee_cv_id)
  end
end
