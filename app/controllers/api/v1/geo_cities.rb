# frozen_string_literal: true

module Api
  module V1
    class GeoCities < Grape::API
      desc 'All cities'

      get '/cities' do
        present :location_city, Geo::City.all.order('name ASC')
       end
    end
  end
end
