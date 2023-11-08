# frozen_string_literal: true

module Api
  module V1
    class Orders < Grape::API
      helpers Api::V1::NamedParams

      before { user_authenticated! }

      desc 'List of published orders',
           tag: ['orders'],
           is_array: true,
           success: Entities::Order
      params do
        use :order_filters
        use :pagination_filters
      end
      get '/orders/published' do
        params[:search] = {} if params[:search].blank?

        q = Order.published
          .ransack(position_title_cont: params[:search][:title], city_name_cont: params[:search][:city_name],
                   category_titles_cont: params[:search][:category_titles], skill_cont: params[:search][:skill])
        orders = q.result.page(params[:page]).per(params[:per]).includes(:position)

        present :orders, orders, with: Entities::Order
        present :page, orders.current_page
        present :total_pages, orders.total_pages
      end

      
      desc 'Show order',
           success: Entities::Order
      params do
        requires :id, type: Integer, desc: 'Order ID'
      end
      get '/orders/:id' do
        order = Order.find(params[:id])

        present :order, order, with: Entities::Order
        present :company, order.profile.company, with: Entities::Company
      end
    end
  end
end
