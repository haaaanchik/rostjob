# frozen_string_literal: true

module Api
  module V1
    module Entities
      module Geo
        class Country < Api::V1::Entities::Base
          expose :id,
                 documentation: {
                   desc: 'Country id.',
                   type: Integer
                 }
          expose :name,
                 documentation: {
                   desc: 'Country name.',
                   type: String
                 }
        end
      end
    end
  end
end
