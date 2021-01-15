# frozen_string_literal: true

module Api
  module V1
    module Entities
      class Order < Api::V1::Entities::Base
        expose(:company_short_name,
               documentation: {
                 desc: 'Order company short name.',
                 type: String
               }
        ) do |order|
          order.profile.company.short_name
        end

        expose :city,
               documentation: {
                 desc: 'Order city.',
                 type: String
               }

        expose :title,
               documentation: {
                 desc: 'Order title.',
                 type: String
               }

        expose :salary,
               documentation: {
                 desc: 'Employee salary.',
                 type: String
               }

        expose :skill,
               documentation: {
                 desc: 'Employee skill.',
                 type: String
               }

        expose :other_info,
               documentation: {
                 desc: 'Order info',
                 type: String
               }

        expose(:created_at,
               format_with: :iso8601,
               documentation: {
                 desc: 'The datetime when order was created.',
                 type: String
               }
        ) do |order|
          Russian::strftime(order.created_at, '%e %B %Y')
        end
      end
    end
  end
end
