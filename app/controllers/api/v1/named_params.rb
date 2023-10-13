# frozen_string_literal: true

module Api
  module V1
    module NamedParams
      extend ::Grape::API::Helpers

      params :pagination_filters do
        optional :per, type: Integer, default: 25, desc: 'Per number (defaults to 25)'
        optional :page, type: Integer, default: 1, desc: 'Page number (defaults to 1)'
      end
    end
  end
end
