# frozen_string_literal: true

module Api
  module V1
    module Geo
      class Cities < Grape::API
        before { user_authenticated! }

        namespace :geo do
          desc 'All cities',
               tags: ['geo'],
               is_array: true,
               success: Entities::Geo::City
          params do
            optional :per, type: Integer, default: 25, desc: 'Per number (defaults to 25)'
            optional :page, type: Integer, default: 1, desc: 'Page number (defaults to 1)'
          end
          get '/cities' do
            cities = ::Geo::City.order('name ASC').page(params[:page]).per(params[:per])

            present :cities, cities, with: Entities::Geo::City
            present :page, cities.current_page
            present :total_pages, cities.total_pages
          end


          desc 'Create new city', tags: ['geo']
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

            present city
          end
        end
      end
    end
  end
end
