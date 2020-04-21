class OrdersController < ApplicationController
  before_action :order, except: :index
  before_action :redirect_to_disputes, only: :index

  def index
    @active_item = :orders
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
    @order_filters = Order.published
                          .with_customer_name
                          .includes(:production_site, profile: :company)
                          .order(advertising: :desc)

    @q = if params[:customer].present?
           Order.published.with_customer_name_by_customer(params[:customer]).order(advertising: :desc).ransack(params[:q])
         else
           @order_filters.ransack(params[:q])
         end
    @orders ||= @q.result
  end

  def employee_cv_id
    @employee_cv_id = params[:employee_cv_id] || params[:q].try(:[], :employee_cv_id)
  end

  def redirect_to_disputes
    return if request.referer.nil?
    path_name = URI(request.referer).path
    if @opened_tickets_count > 0 && !path_name.include?('/profile/tickets/')
      flash[:notice] = 'У вас есть анкета с открытым спором, пожалуйста просмотрите его!'
      redirect_to profile_ticket_path(@opened_tickets.first)
    end
  end
end
