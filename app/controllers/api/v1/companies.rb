# frozen_string_literal: true

module Api
  module V1
    class Companies < Grape::API
      helpers Api::V1::NamedParams

      before { user_authenticated! }

      desc 'Company info',
           success: Entities::Company
      params do
        requires :id, type: Integer, desc: 'User ID'
      end
      get '/companies/:id/info' do
        company = User.find(params[:id]).profile.company

        present company, with: Entities::Company
      end


      desc 'List of company orders',
           is_array: true,
           success: Entities::Order
      params do
        requires :id, type: Integer, desc: 'User ID'
        use :order_filters
        optional :search, type: Hash do
          optional :state, type: String, desc: 'Search by state', values: Order.aasm.states.map(&:name).map(&:to_s)
        end
        use :pagination_filters
      end
      get '/companies/:id/orders' do
        params[:search] = {} if params[:search].blank?

        company = User.find(params[:id]).profile
        q = company.orders.ransack(position_title_cont: params[:search][:title],
                                   city_name_cont: params[:search][:city_name],
                                   category_titles_cont: params[:search][:category_titles],
                                   skill_cont: params[:search][:skill], state_eq: params[:search][:state])
        orders = q.result.page(params[:page]).per(params[:per]).includes(:position)

        present :orders, orders, with: Entities::Order
        present :page, orders.current_page
        present :total_pages, orders.total_pages
      end
    end
  end
end
