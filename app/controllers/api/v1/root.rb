# frozen_string_literal: true

require_dependency 'api/v1/errors'

module Api
  module V1
    class Root < Grape::API
      version 'v1'

      default_format :json

      helpers Api::V1::Auth

      rescue_from(ActiveRecord::RecordNotFound) { |_e| error!({ errors: 'Record Not Found' }, 404) }

      mount Api::V1::Geo::Countries
      mount Api::V1::Geo::Regions
      mount Api::V1::Geo::Cities
      mount Api::V1::Orders
      mount Api::V1::Positions
      mount Api::V1::PriceGroups
      mount Api::V1::Specializations

      add_swagger_documentation(
        base_path: '/api',
        hide_documentation_path: true,
        api_version: 'v1',
        info: { title: 'User API v1' }
      )
    end
  end
end
