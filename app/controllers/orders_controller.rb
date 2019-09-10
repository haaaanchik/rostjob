class OrdersController < ApplicationController
  before_action :order, except: :index

  def index
    @term = params[:customer]
    @active_item = case params[:customer]
                   when nil
                     :orders
                   when 'rost'
                     :rost
                   when 'avangard'
                     :avangard
                   end

    employee_cv_id
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
    @q = if params[:customer].present?
           Order.published.with_customer_name_by_customer(params[:customer]).order(advertising: :desc).ransack(params[:q])
         else
           Order.published.with_customer_name.order(advertising: :desc).ransack(params[:q])
         end
    @orders ||= @q.result
  end

  def employee_cv_id
    @employee_cv_id = params[:employee_cv_id] || params[:q].try(:[], :employee_cv_id)
  end
end
