# frozen_string_literal: true

module Api
  module V1
    class PriceGroups < Grape::API
      helpers Api::V1::NamedParams

      before { user_authenticated! }

      desc 'List of price groups',
           is_array: true,
           success: Entities::PriceGroup
      params do
        optional :search, type: String, desc: 'Search by title'
        use :pagination_filters
      end
      get '/price_groups' do
        q = PriceGroup.ransack(title_cont: params[:search])
        price_groups = q.result.page(params[:page]).per(params[:per])

        present :price_groups, price_groups, with: Entities::PriceGroup
        present :page, price_groups.current_page
        present :total_pages, price_groups.total_pages
      end

      desc 'Show price group',
           success: Entities::PriceGroup
      params do
        requires :id, type: Integer, desc: 'PriceGroup ID'
      end
      get '/price_groups/:id' do
        present PriceGroup.find(params[:id]), with: Entities::PriceGroup
      end

      desc 'Create new price group',
           success: Entities::PriceGroup
      params do
        requires :title, type: String, desc: 'Title'
        requires :customer_price, type: Integer, desc: 'Customer price'
        requires :contractor_price, type: Integer, desc: 'Contractor price'
      end
      post '/price_groups' do
        price_group = PriceGroup.create(title: params[:title],
                                        customer_price: params[:customer_price],
                                        contractor_price: params[:contractor_price])

        present price_group, with: Entities::PriceGroup
      end


      desc 'Update price group details',
           success: Entities::PriceGroup
      params do
        requires :id, type: Integer, desc: 'PriceGroup ID'
        optional :title, type: String, desc: 'Title'
        optional :customer_price, type: Integer, desc: 'Customer price'
        optional :contractor_price, type: Integer, desc: 'Contractor price'
      end
      put '/price_groups/:id' do
        price_group = PriceGroup.find(params[:id])
        price_group.update(params.slice('title', 'customer_price', 'contractor_price'))

        present price_group, with: Entities::PriceGroup
      end
    end
  end
end
