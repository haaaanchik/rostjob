class OrdersController < ApplicationController
  before_action :order, except: :index

  def index
    @employee_cv_id = order_search_form_params[:employee_cv_id] if order_search_form_params
    @order_search_form = if @employee_cv_id
                           osf_params = order_search_form_params.merge(profile: current_profile)
                           OrderSearchForm2.new(osf_params)
                         else
                           OrderSearchForm.new(order_search_form_params)
                         end
    @orders = @order_search_form.submit
  end

  def show
    render locals: { order: @order }
  end

  def add_to_favorites
    Cmd::Order::AddToFavorites.call(order: order, profile: current_profile)
  end

  def remove_from_favorites
    Cmd::Order::RemoveFromFavorites.call(order: order, profile: current_profile)
  end

  private

  def order
    @order = Order.find(params[:id]).decorate
  end

  def order_search_form_params
    params.permit(order_search_form: %i[query sort_by filter_by employee_cv_id])[:order_search_form]
  end
end
