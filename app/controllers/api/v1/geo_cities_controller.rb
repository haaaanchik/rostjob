# frozen_string_literal: true

module Api
  module V1
    class GeoCitiesController < ApiV1Controller
      def index
        # TODO: https://trello.com/c/qTiM53bI/
        location_city = Geo::City.all.order('name ASC')
        cities_orders = Geo::City.joins(:orders).where("orders.state = 'published'").distinct

        render json: {
          objects: GeoCitiesSerializer.serialized_collection(cities_orders),
          location_city: location_city
        }
      end
    end
  end
end
