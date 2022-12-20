# frozen_string_literal: true

class Admin::OrdersController < Admin::ApplicationController
  def index
    paginated_orders
  end

  def show
    order
  end

  def accept
    Cmd::Order::ToPublished.call(order: order)
    redirect_to admin_orders_path
  end

  def refresh_new_label
    order.refresh_new_label!
    redirect_to admin_orders_path
  end

  def reject
    if params[:reason].empty?
      flash[:alert] = 'Не указана причина отказа'
      redirect_to admin_order_path(order)
    else
      order.to_rejected(params[:reason])
      redirect_to admin_orders_path
    end
  end

  def edit
    order
  end

  def update
    result = Cmd::Order::Update.call(order: order, params: order_params)
    if result.success?
      redirect_to admin_order_path(order)
    else
      render json: { validate: true, data: errors_data(result.order) }, status: 422
    end
  end

  private

  def paginated_orders
    @paginated_orders ||= orders.page(params[:page])
  end

  def order
    @order ||= Order.find(params[:id])
  end

  def order_params
    params.require(:order)
      .permit(:email, :city_id, :phone_number, :skill, :name, :state, :number_of_employees, :salary, :contractor_price,
              :advertising, :adv_text, :shift_method, :food_nutrition, :housing, contact_person: {}, other_info: {})
  end

  def orders
    @orders ||= Order.moderation
  end
end
