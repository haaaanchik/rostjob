# frozen_string_literal: true

module Api
  module V1
    class Orders < Grape::API
      desc 'Catalog orders. Only published orders' do
        is_array true
        success Entities::Order
      end
      params do
        optional :page, type: Integer, default: 1, desc: 'Specify the page of paginated results.'
        optional :city_eq, type: String, desc: 'Order city.'
        optional :title_fields_in, type: Array, desc: 'Order title.'
        optional :title_or_company_fields_cont, type: String, desc: 'Search by order title or company name.'
        optional :profile_id_eq, type: String, desc: 'customer id'
      end

      get '/orders/catalog' do
        orders = published_orders.ransack(params).result.page(params[:page])

        present :total_pages, orders.total_pages
        present :orders, orders, with: Entities::Order, base_url: request.base_url
        present :titles, published_orders.map(&:title).uniq
        present :cities, published_orders.map(&:city).uniq
      end


      desc 'Order by id' do
        success Entities::Order
      end
      params do
        requires :id, type: Integer, desc: 'Order id'
      end
      get '/orders/:id' do
        order = published_orders.find(params[:id])
        similar_orders = published_orders
                           .where(city: order.city)
                           .where.not(id: order.id)
                           .limit(2)

        present :order, order, with: Entities::Order, base_url: request.base_url
        present :similar_orders, similar_orders, with: Entities::Order, base_url: request.base_url
      end
    end
  end
end
