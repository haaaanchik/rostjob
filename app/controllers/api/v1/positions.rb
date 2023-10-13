# frozen_string_literal: true

module Api
  module V1
    class Positions < Grape::API
      helpers Api::V1::NamedParams

      before { user_authenticated! }

      desc 'List of positions',
           is_array: true,
           success: Entities::Position
      params do
        optional :search, type: String, desc: 'Search by title'
        use :pagination_filters
      end
      get '/positions' do
        q = Position.ransack(title_cont: params[:search])
        positions = q.result.page(params[:page]).per(params[:per])

        present :positions, positions, with: Entities::Position
        present :page, positions.current_page
        present :total_pages, positions.total_pages
      end


      desc 'Show position',
           success: Entities::Position
      params do
        requires :id, type: Integer, desc: 'Position ID'
      end
      get '/positions/:id' do
        present Position.find(params[:id]), with: Entities::Position
      end


      desc 'Create new positions',
           success: Entities::Position
      params do
        requires :title, type: String, desc: 'Title'
        optional :warranty_period, type: Integer, default: 10, desc: 'Warranty period (defaults to 10)'
        requires :landing_title, type: String, desc: 'Title to landing'
        optional :duties, type: String, desc: 'Duties'
        optional :description, type: String, desc: 'Description'
        requires :price_group_id, type: Integer, desc: 'Price group'
        requires :slug, type: String, desc: 'URL'
      end
      post '/positions' do
        position = Position.create(title: params[:title], warranty_period: params[:warranty_period],
                                   landing_title: params[:landing_title], duties: params[:duties],
                                   description: params[:description], price_group_id: params[:price_group_id],
                                   slug: params[:slug])

        present position, with: Entities::Position
      end


      desc 'Update position details',
           success: Entities::Position
      params do
        requires :id, type: Integer, desc: 'Position ID'
        optional :title, type: String, desc: 'Title'
        optional :warranty_period, type: Integer, desc: 'Warranty period (defaults to 10)'
        optional :landing_title, type: String, desc: 'Title to landing'
        optional :duties, type: String, desc: 'Duties'
        optional :description, type: String, desc: 'Description'
        optional :price_group_id, type: Integer, desc: 'Price group'
        optional :slug, type: String, desc: 'URL'
      end
      put '/positions/:id' do
        position = Position.find(params[:id])
        position.update(params.slice('title', 'warranty_period', 'landing_title',
                                     'duties', 'description', 'price_group_id', 'slug'))

        present position, with: Entities::Position
      end
    end
  end
end
