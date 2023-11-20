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
        expose :phone_number,
               documentation: {
                 desc: 'Phone number.',
                 type: String
               }
        expose :gender,
               documentation: {
                 desc: 'Gender.',
                 type: String
               }
        expose :order_id,
               documentation: {
                 desc: 'Order ID.',
                 type: Integer
               }
        expose :experience,
               documentation: {
                 desc: 'Experience.',
                 type: String
               }
        expose :education,
               documentation: {
                 desc: 'Education.',
                 type: String
               }
        expose :remark,
               documentation: {
                 desc: 'Remark.',
                 type: String
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
