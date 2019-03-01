class PricesController < ApplicationController
  # skip_before_action :authenticate_user!
  skip_before_action :auth_user

  def show
    paginated_price_items
  end

  private

  def term_is_valid
    params[:term] && !params[:term].empty?
  end

  def paginated_price_items
    @paginated_price_items ||= price_items.page(params[:page])
  end

  def price_items
    @price_items ||= if term_is_valid
                       term = "#{params[:term].downcase}%"
                       Position.where('lower(title) like ?', term).order(title: :asc)
                     else
                       Position.order(title: :asc)
                     end
  end
end
