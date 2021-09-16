# frozen_string_literal: true

module Geo
  class CityDecorator < ApplicationDecorator
    delegate_all

    def full_name
      "#{name}, #{country_name}"
    end

    def full_name_with_region
      needed_display_region? ? "#{name}, #{region_name}, #{country_name}" : "#{name}, #{country_name}"
    end

    private

    def needed_display_region?
      region_name.present? && name.squish.downcase != region_name.squish.downcase
    end
  end
end
