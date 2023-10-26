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
        optional :search, type: Hash do
          optional :title, type: String, desc: 'Search by order title'
          optional :city_name, type: String, desc: 'Search by city name'
          optional :category_title, type: String, desc: 'Search by specialization title'
          optional :skill, type: String, desc: 'Search by skill'
        end
        use :pagination_filters
      end
      get '/orders/published' do
        params[:search] = {} if params[:search].blank?

        q = Order.published
          .ransack(title_cont: params[:search][:title], city_name_cont: params[:search][:city_name],
                   category_titles_cont: params[:search][:category_titles], skill_cont: params[:search][:skill])
        orders = q.result.page(params[:page]).per(params[:per]).includes(:position)

        present :orders, orders, with: Entities::Order
        present :page, orders.current_page
        present :total_pages, orders.total_pages
      end
    end
  end
end
