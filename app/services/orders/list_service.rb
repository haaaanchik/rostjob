# frozen_string_literal: true

module Orders
  class ListService < ::ApplicationService
    EARTH_RADIUS = 637_8137
    DEFAULT_DISTANCE = 1_000.0
    DISTANCE = {
      'near' => 100_000.0,
      'next' => 300_000.0,
      'far' => 5_000_000.0
    }.freeze

    attr_accessor :user_location, :radius_of_cities, :without_experience, :advert, :q, :sort_salary, :sort_date

    def process
      @result = advert ? advert_orders : filter_orders(search_orders_by_radius).ransack(q).result(distinct: true)
    end

    private

    def advert_orders
      published_orders.where(advertising: true)
    end

    def filter_orders(search_orders)
      if sort_salary.present?
        search_orders.order(Arel.sql('orders.salary + 0 desc'))
      elsif sort_date.present?
        search_orders.order(created_at: :desc)
      elsif without_experience
        search_orders.where('customer_price <= 9000')
      else
        search_orders
      end
    end

    def search_orders_by_radius
      return published_orders if radius_of_cities.blank?
      return published_orders if city.blank?

      q[:city_name_eq] = nil if user_location.present?

      published_orders.where(city_id: closer_city_ids)
    end

    def city
      @city ||= Geo::City.find_by(name: city_name)
    end

    def coordinates
      @coordinates ||= calculate_closer_cities(city.lat, city.long)
    end

    def closer_city_ids
      Geo::City
        .where(
          lat: coordinates[:y0]..coordinates[:y1],
          long: coordinates[:x0]..coordinates[:x1]
        ).pluck(:id)
    end

    def published_orders
      PublishedOrdersSpecification.to_scope
    end

    def city_name
      return user_location if q[:city_name_eq].blank?

      q[:city_name_eq]
    end

    def calculate_closer_cities(lat, long)
      latitude = Math.cos(Math::PI / 180.0 * lat)
      distance = DISTANCE[radius_of_cities].presence || DEFAULT_DISTANCE

      {
        y0: lat - (180 / Math::PI) * (distance / EARTH_RADIUS),
        y1: lat + (180 / Math::PI) * (distance / EARTH_RADIUS),
        x0: long - (180 / Math::PI) * (distance / EARTH_RADIUS) / Math.cos(latitude),
        x1: long + (180 / Math::PI) * (distance / EARTH_RADIUS) / Math.cos(latitude)
      }
    end
  end
end
