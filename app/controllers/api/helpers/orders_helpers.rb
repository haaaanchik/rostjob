# frozen_string_literal

module Api
  module Helpers
    module OrdersHelpers

      EARTH_RADIUS = 6378137

      def calculate_closer_cities(lat, long)
        lat0 = Math.cos(Math::PI / 180.0 * lat)
        {
            y0: lat - (180/Math::PI)*(distance/EARTH_RADIUS),
            y1: lat + (180/Math::PI)*(distance/EARTH_RADIUS),
            x0: long - (180/Math::PI)*(distance/EARTH_RADIUS)/Math.cos(lat0),
            x1: long + (180/Math::PI)*(distance/EARTH_RADIUS)/Math.cos(lat0)
        }
      end

      def distance
        case params[:radius_of_cities]
        when 'near'
          100000.0
        when 'next'
          300000.0
        when 'far'
          5000000.0
        else
          1000.0
        end
      end

      def search_orders_by_radius
        return published_orders if params[:radius_of_cities].blank?

        city = Geo::City.find_by(name: params[:q]['city_name_eq'] || params[:user_location])
        return published_orders if city.blank?

        coordinates = calculate_closer_cities(city.lat, city.long)
        closer_city_ids = Geo::City.where( lat: coordinates[:y0]..coordinates[:y1], long: coordinates[:x0]..coordinates[:x1] ).pluck(:id)
        Order.where(city_id: closer_city_ids).published
      end

      def published_orders
        Order.published.includes(:city, :position, profile: :company)
      end

      def orders_sort(orders)
        if params[:sort_salary].present?
          sort_by_salary(orders)
        elsif params[:sort_date].present?
          sort_by_date(orders)
        else
          orders
        end
      end

      def sort_by_salary(orders)
        orders.order(Arel.sql("orders.salary + 0 desc"))
      end

      def sort_by_date(orders)
        orders.order(created_at: :desc)
      end
    end
  end
end
