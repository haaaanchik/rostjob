class OrdersController < ApplicationController
  before_action :order, except: %i[index customer_orders info]
  before_action :redirect_to_disputes, only: :index

  def index
    @active_item = :orders
    @customer_list = Kaminari.paginate_array(search_customer.decorate.uniq).page(params[:page])

  end

  def customer_orders
    @active_item = :orders
    orders.decorate
  end

  def add_to_favorites
    @employee_cv_id = params[:employee_cv_id]
    Cmd::Order::AddToFavorites.call(order: order, profile: current_profile)
  end

  def remove_from_favorites
    @employee_cv_id = params[:employee_cv_id]
    Cmd::Order::RemoveFromFavorites.call(order: order, profile: current_profile)
  end

  def info
    @order = Order.find(params[:id]).decorate
  end

  private

  def order
    @order = Order.with_customer_name.find(params[:id]).decorate
  end

  def orders
    @customer = Profile.find(params[:customer_id])
    @order_filters = @customer.orders
                         .published
                         .with_customer_name
                         .includes(:production_site, profile: :company)
    @q = @order_filters.ransack(params[:q])
    @orders ||= @q.result
  end

  def search_customer
    @orders = Order.published
                  .with_customer_name
                  .includes(:production_site, profile: :company)
    @q = Profile.joins(:orders)
             .where('orders.state': 'published')
             .customers.includes(:user, :company)
             .order(rating: :desc).ransack(params[:q])
    @q.result
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
