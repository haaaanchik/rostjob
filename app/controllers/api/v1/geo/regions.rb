# frozen_string_literal: true

module Api
  module V1
    module Geo
      class Regions < Grape::API
        helpers Api::V1::NamedParams

        before { user_authenticated! }

        namespace :geo do
          desc 'List of regions',
               tags: ['geo'],
               is_array: true,
               success: Entities::Geo::Region
          params do
            optional :search, type: String, desc: 'Search by name'
            use :pagination_filters
          end
          get '/regions' do
            q = ::Geo::Region.ransack(name_cont: params[:search])
            regions = q.result.order('name ASC').page(params[:page]).per(params[:per])

            present :regions, regions, with: Entities::Geo::Region
            present :page, regions.current_page
            present :total_pages, regions.total_pages
          end


          desc 'Show region',
               tags: ['geo'],
               success: Entities::Geo::Region
          params do
            requires :id, type: Integer, desc: 'Region ID'
          end
          get '/cities/:id' do
            present ::Geo::Region.find(params[:id]), with: Entities::Geo::Region
          end


          desc 'Create new region', tags: ['geo']
          params do
            requires :name, type: String, desc: 'Region name'
            requires :country_id, type: Integer, desc: 'Country for region'
          end
          post '/regions' do
            region = ::Geo::Region.create(name: params[:name], country_id: params[:country_id])

            present region
          end


          desc 'Update region details',
               tags: ['geo'],
               success: Entities::Geo::Region
          params do
            requires :id, type: Integer, desc: 'Region ID'
            optional :name, type: String, desc: 'Region name'
            optional :country_id, type: Integer, desc: 'Country for region'
          end
          put '/regions/:id' do
            region = ::Geo::Region.find(params[:id])
            region.update(params.slice('name', 'country_id'))

            present region, with: Entities::Geo::Region
          end
        end
      end
    end
  end
end
