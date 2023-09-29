# frozen_string_literal: true

module Api
  module V1
    module Geo
      class Regions < Grape::API
        before { user_authenticated! }

        namespace :geo do
          desc 'All regions', tags: ['geo']
          params do
            optional :per, type: Integer, default: 25, desc: 'Per number (defaults to 25)'
            optional :page, type: Integer, default: 1, desc: 'Page number (defaults to 1)'
          end
          get '/regions' do
            regions = ::Geo::Region.order('name ASC').page(params[:page]).per(params[:per])

            present :regions, regions, with: Entities::Geo::Region
            present :page, regions.current_page
            present :total_pages, regions.total_pages
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
        end
      end
    end
  end
end
