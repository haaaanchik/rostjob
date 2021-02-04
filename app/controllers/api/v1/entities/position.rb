# frozen_string_literal: true

module Api
  module V1
    module Entities
      class Position < Api::V1::Entities::Base
        expose :title,
               documentation: {
                 desc: 'Position title.',
                 type: String
               }

        expose(:customer_price,
               documentation: {
                 desc: 'Price Group customer_price.',
                 type: String
               }
        ) do |position|
          position.price_group.customer_price.to_i
        end
      end
    end
  end
end
