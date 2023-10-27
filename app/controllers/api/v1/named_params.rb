# frozen_string_literal: true

module Api
  module V1
    module NamedParams
      extend ::Grape::API::Helpers

      params :pagination_filters do
        optional :per, type: Integer, default: 25, desc: 'Per number (defaults to 25)'
        optional :page, type: Integer, default: 1, desc: 'Page number (defaults to 1)'
      end

      params :order_filters do
        optional :search, type: Hash do
          optional :title, type: String, desc: 'Search by order title'
          optional :city_name, type: String, desc: 'Search by city name'
          optional :category_title, type: String, desc: 'Search by specialization title'
          optional :skill, type: String, desc: 'Search by skill'
        end
      end
    end
  end
end
