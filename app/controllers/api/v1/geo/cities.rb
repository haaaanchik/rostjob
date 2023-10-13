# frozen_string_literal: true

module Api
  module V1
    module Geo
      class Cities < Grape::API
        helpers Api::V1::NamedParams

        before { user_authenticated! }

        namespace :geo do
          desc 'List of cities',
               tags: ['geo'],
               is_array: true,
               success: Entities::Geo::City
          params do
            optional :search, type: String, desc: 'Search by name'
            use :pagination_filters
          end
          get '/cities' do
            q = ::Geo::City.ransack(name_cont: params[:search])
            cities = q.result.order('name ASC').page(params[:page]).per(params[:per])

            present :cities, cities, with: Entities::Geo::City
            present :page, cities.current_page
            present :total_pages, cities.total_pages
          end


          desc 'Show city',
               tags: ['geo'],
               success: Entities::Geo::City
          params do
            requires :id, type: Integer, desc: 'City ID'
          end
          get '/cities/:id' do
            present ::Geo::City.find(params[:id]), with: Entities::Geo::City
          end


          desc 'Create new cities',
               tags: ['geo'],
               success: Entities::Geo::City
          params do
            requires :name, type: String, desc: 'City name'
            optional :synonym, type: String, desc: 'City synonym'
            optional :fias_code, type: String, desc: 'City fias_code'
            optional :lat, type: BigDecimal, desc: 'City latitude'
            optional :long, type: BigDecimal, desc: 'City longitude'
            requires :region_id, type: Integer, desc: 'Region for city'
          end
          post '/cities' do
            city = ::Geo::City.create(name: params[:name], synonym: params[:synonym], fias_code: params[:fias_code],
                                      lat: params[:lat], long: params[:long], region_id: params[:region_id])

            present city, with: Entities::Geo::City
          end


          desc 'Update city details',
               tags: ['geo'],
               success: Entities::Geo::City
          params do
            requires :id, type: Integer, desc: 'City ID'
            optional :name, type: String, desc: 'City name'
            optional :synonym, type: String, desc: 'City synonym'
            optional :fias_code, type: String, desc: 'City fias_code'
            optional :lat, type: BigDecimal, desc: 'City latitude'
            optional :long, type: BigDecimal, desc: 'City longitude'
            requires :region_id, type: Integer, desc: 'Region for city'
          end
          put '/cities/:id' do
            city = ::Geo::City.find(params[:id])
            city.update(params.slice('name', 'synonym', 'fias_code', 'lat', 'long', 'region_id'))

            present city, with: Entities::Geo::City
          end
        end
      end
    end
  end
end
