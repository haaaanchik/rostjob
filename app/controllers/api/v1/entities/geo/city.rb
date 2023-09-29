# frozen_string_literal: true

module Api
  module V1
    module Entities
      module Geo
        class City < Api::V1::Entities::Base
          expose :id,
                 documentation: {
                   desc: 'City id.',
                   type: Integer
                 }
          expose :name,
                 documentation: {
                   desc: 'City name.',
                   type: String
                 }
          expose :synonym,
                 documentation: {
                   desc: 'Synonym name.',
                   type: String
                 }
          expose :fias_code,
                 documentation: {
                   desc: 'Fias code city.',
                   type: String
                 }
          expose :lat,
                 documentation: {
                   desc: 'Latitude city.',
                   type: BigDecimal
                 }
          expose :long,
                 documentation: {
                   desc: 'Longitude city.',
                   type: BigDecimal
                 }
          expose :region_id,
                 documentation: {
                   desc: 'Region id.',
                   type: Integer
                 }
        end
      end
    end
  end
end
