# frozen_string_literal: true

module Api
  module V1
    class Orders < Grape::API

      desc 'Catalog orders. Only published orders' do
        is_array true
        success Entities::Order
      end
      params do
        optional :page,  type: Integer, default: 1, desc: 'Specify the page of paginated results.'
        optional :city_eq, type: String, desc: 'Order city.'
        optional :title_fields_in, type: Array, desc: 'Order title.'
        optional :title_or_company_fields_cont, type: String, desc: 'Search by order title or company name.'
      end

      get '/orders/catalog' do
        published_orders = Order.published.includes(:position, profile: :company)
        orders = published_orders.ransack(params).result.page(params[:page])

        present :total_pages, orders.total_pages
        present :orders, orders, with: Entities::Order
        present :titles, published_orders.map(&:title).uniq
        present :cities, published_orders.map(&:city).uniq
      end
    end
  end
end
