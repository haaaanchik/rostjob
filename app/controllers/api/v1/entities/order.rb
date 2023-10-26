# frozen_string_literal: true

module Api
  module V1
    module Entities
      class Order < Api::V1::Entities::Base
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
        expose :city_id,
               documentation: {
                 desc: 'City id.',
                 type: Integer
               }
        expose :number_of_employees,
               documentation: {
                 desc: 'Number of employees.',
                 type: Integer
               }
        expose :customer_price,
               documentation: {
                 desc: 'Сustomer price.',
                 type: Integer
               }
        expose :contractor_price,
               documentation: {
                 desc: 'Сontractor price.',
                 type: Integer
               }
        expose :other_info,
               documentation: {
                 desc: 'Other info.',
                 type: Hash
               }
        expose :skill,
               documentation: {
                 desc: 'Skill.',
                 type: String
               }
        expose :contact_person,
               documentation: {
                 desc: 'Contact person.',
                 type: Hash
               }
        expose :salary,
               documentation: {
                 desc: 'Salary.',
                 type: String
               }
        expose :advertising,
               documentation: {
                 desc: 'Advertising.',
                 type: Grape::API::Boolean
               }
        expose :adv_text,
               documentation: {
                 desc: 'Advertising text.',
                 type: String
               }
        expose :housing,
               documentation: {
                 desc: 'Housing.',
                 type: Grape::API::Boolean
               }
        expose :food_nutrition,
               documentation: {
                 desc: 'Food nutrition.',
                 type: Grape::API::Boolean
               }
        expose :shift_method,
               documentation: {
                 desc: 'Shift method.',
                 type: Grape::API::Boolean
               }
        expose :published_at,
               format_with: :iso8601,
               documentation: {
                 desc: 'Published at.',
                 type: Date
               }
      end
    end
  end
end
