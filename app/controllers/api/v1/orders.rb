# frozen_string_literal: true

module Api
  module V1
    class Orders < Grape::API
      desc 'Catalog orders. Only published orders' do
        is_array true
        success Entities::Order
      end
      params do
        optional :q, type: Hash do
          optional :city_name_eq, type: String, desc: 'Order city.'
          optional :category_titles_in, type: Array, desc: 'Order by specialization.'
          optional :title_or_company_fields_cont, type: String, desc: 'Search by order title or company name.'
          optional :shift_method_eq, type: Boolean, desc: 'Order shift method'
          optional :food_nutrition_eq, type: Boolean, desc: 'Order food_nutrition'
          optional :housing_eq, type: Boolean, desc: 'Order housing'
        end
        optional :user_location, type: String, desc: 'User location'
        optional :radius_of_cities, type: String, values: %w[near next far], desc: 'Radius cities'
        optional :page, type: Integer, default: 1, desc: 'Specify the page of paginated results.'
        optional :without_experience, type: Integer, values: [0, 1], default: 0, desc: 'Orders with a price of 8000 or less'
      end

      get '/orders/catalog' do
        params[:q] = {} if params[:q].blank?
        params[:q][:without_experience_field_lteq] = 8000 if params[:without_experience].positive?

        p_orders = search_orders_by_radius
        result = p_orders.ransack(params[:q]).result
        orders = result.page(params[:page])

        present :total_orders, result.count
        present :total_pages, orders.total_pages
        present :orders, orders_sort(orders), with: Entities::Order, base_url: request.base_url
        present :categories, ActiveSpecializationsSpecification.to_scope.map(&:title)
        present :cities, published_orders.map { |order|
          {
              name: order.city&.name,
              lat: order.city&.lat,
              long: order.city&.long
          }
        }.uniq.compact
      end


      desc 'Order with advertising' do
        success Entities::Order
      end
      get '/orders/advertising' do
        orders = published_orders
                   .where(advertising: true)

        present :orders, orders, with: Entities::Order, base_url: request.base_url
        present :cities, published_orders.map { |order| order.city&.name }.uniq
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
                           .where(city_id: order.city_id)
                           .where.not(id: order.id)
                           .limit(2)

        present :order, order, with: Entities::Order, base_url: request.base_url
        present :similar_orders, similar_orders, with: Entities::Order, base_url: request.base_url
      end
    end
  end
end
