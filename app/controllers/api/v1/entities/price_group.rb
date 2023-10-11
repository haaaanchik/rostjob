# frozen_string_literal: true

module Api
  module V1
    module Entities
      class PriceGroup < Api::V1::Entities::Base
        expose :id,
               documentation: {
                 desc: 'Id.',
                 type: Integer
               }
        expose :title,
               documentation: {
                 desc: 'Title.',
                 type: String
               }
        expose :customer_price,
               documentation: {
                 desc: 'Customer price.',
                 type: BigDecimal
               }
        expose :contractor_price,
               documentation: {
                 desc: 'Contractor price.',
                 type: BigDecimal
               }
        expose :created_at, format_with: :iso8601, documentation: {
          type: DateTime,
          desc: 'Price Group create time in iso8601 format.'
        }
        expose :updated_at, format_with: :iso8601, documentation: {
          type: DateTime,
          desc: 'Price Group update time in iso8601 format.'
        }
      end
    end
  end
end
