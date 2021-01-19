# frozen_string_literal: true

require_dependency 'api/v1/errors'

module Api
  module V1
    class Root < Grape::API
      version 'v1'

      default_format :json

      include Api::V1::Auth
      mount Api::V1::Orders
      mount Api::V1::Contractors

      add_swagger_documentation(
        base_path: '/api',
        hide_documentation_path: true,
        api_version: 'v1',
        info: { title: 'User API v1' }
      )
    end
  end
end
