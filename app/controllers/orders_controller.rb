class OrdersController < ApplicationController
  def index
    @fav = params[:favorable_id]
    if @fav
      list = Favorite.includes(:favorable).where user_id: params[:favorable_id],
                                                 favorable_type: 'Order'
      @orders = list.map(&:favorable) if list
    else
      @order_search_form = OrderSearchForm.new(order_search_form_params)
      @orders = @order_search_form.submit
    end

  end

  def show
    new_proposal = Proposal.new
    new_proposal.messages.build
    render locals: {order: order, new_proposal: new_proposal}
  end

  def manage_fav
    order
    favs = @order.favorites

    if params[:tag] == 'star'
      favs.create user_id: current_user.id
    else
      fv = Favorite.find_by id: params[:fav]
      favs.destroy fv
    end
  end

  private

  def order
    @order = Order.includes(:favorites).find(params[:id])
  end

  def order_search_form_params
    params.permit(order_search_form: %i[query sort_by filter_by])[:order_search_form]
  end
end
