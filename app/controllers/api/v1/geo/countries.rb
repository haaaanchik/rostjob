# frozen_string_literal: true

module Api
  module V1
    module Geo
      class Countries < Grape::API
        before { user_authenticated! }

        namespace :geo do
          desc 'All countries', tags: ['geo']
          params do
            optional :per, type: Integer, default: 25, desc: 'Per number (defaults to 25)'
            optional :page, type: Integer, default: 1, desc: 'Page number (defaults to 1)'
          end
          get '/countries' do
            countries = ::Geo::Country.order('name ASC').page(params[:page]).per(params[:per])

            present :countries, countries, with: Entities::Geo::Country
            present :page, countries.current_page
            present :total_pages, countries.total_pages
          end


          desc 'Create new country', tags: ['geo']
          params do
            requires :name, type: String, desc: 'Country name'
          end
          post '/countries' do
            country = ::Geo::Country.create(name: params[:name])

            present country
          end
        end
      end
    end
  end
end
