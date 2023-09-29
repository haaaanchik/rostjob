# frozen_string_literal: true

module Api
  module V1
    module Entities
      module Geo
        class Region < Api::V1::Entities::Base
          expose :id,
                 documentation: {
                   desc: 'Region id.',
                   type: Integer
                 }
          expose :name,
                 documentation: {
                   desc: 'Region name.',
                   type: String
                 }
          expose :country_id,
                 documentation: {
                   desc: 'Country id.',
                   type: Integer
                 }
        end
      end
    end
  end
end
