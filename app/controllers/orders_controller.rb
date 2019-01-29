class OrdersController < ApplicationController
  before_action :order, except: :index

  def index
    @order_search_form = OrderSearchForm.new(order_search_form_params)
    @orders = @order_search_form.submit
  end

  def show
    new_proposal = Proposal.new
    new_proposal.messages.build
    render locals: {order: @order, new_proposal: new_proposal}
  end

  def manage_fav
    favs = @order.favorites

    if params[:tag] == 'star'
      favs.create user_id: current_user.id
      cr = @order.proposals.create accepted: true,
                                  profile_id: current_profile.id
      cr.messages.create! text: 'СООБЩЕНИЕ ДЛЯ ЗАКАЗЧИКА',
                          sender_id: current_profile.id
    else
      fv = Favorite.find_by id: params[:fav]
      Proposal.destroy params[:proposal_id]
      favs.destroy fv
    end
  end

  def add_to_favorites
    Cmd::Order::AddToFavorites.call(order: order, profile: current_profile)
  end

  def remove_from_favorites
    Cmd::Order::RemoveFromFavorites.call(order: order, profile: current_profile)
  end

  private

  def order
    @order = Order.find(params[:id])
  end

  def order_search_form_params
    params.permit(order_search_form: %i[query sort_by filter_by])[:order_search_form]
  end
end
