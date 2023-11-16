# frozen_string_literal: true

module Api
  module V1
    module Entities
      class EmployeeCv < Api::V1::Entities::Base
        expose :id,
               documentation: {
                 desc: 'Id.',
                 type: Integer
               }
        expose :name,
               documentation: {
                 desc: 'Name.',
                 type: String
               }
        expose :order_id,
               documentation: {
                 desc: 'Order ID.',
                 type: Integer
               }
        expose :state,
               documentation: {
                 desc: 'State.',
                 type: String
               }
      end
    end
  end
end
