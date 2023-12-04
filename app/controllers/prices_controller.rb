class PricesController < ApplicationController
  # skip_before_action :authenticate_user!
  skip_before_action :auth_user

  def show
    add_breadcrumb('Главная', industrial_path)
    add_breadcrumb('Прайс', price_path)
    paginated_price_items
  end

  private

  def term_is_valid
    params[:term] && !params[:term].empty?
  end

  def paginated_price_items
    @paginated_price_items ||= price_items.includes(:price_group).page(params[:page])
  end

  def price_items
    @q = Position.order(title: :asc).ransack(params[:q])
    @q.result
  end
end
