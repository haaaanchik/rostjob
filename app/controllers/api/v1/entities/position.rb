# frozen_string_literal: true

module Api
  module V1
    module Entities
      class Position < Api::V1::Entities::Base
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
        expose :warranty_period,
               documentation: {
                 desc: 'Warranty period (defaults to 10).',
                 type: String
               }
        expose :landing_title,
               documentation: {
                 desc: 'Landing title.',
                 type: String
               }
        expose :duties,
               documentation: {
                 desc: 'Duties.',
                 type: String
               }
        expose :description,
               documentation: {
                 desc: 'Description.',
                 type: String
               }
        expose :price_group_id,
               documentation: {
                 desc: 'Price group id.',
                 type: Integer
               }
        expose :slug,
               documentation: {
                 desc: 'Slug.',
                 type: String
               }
        expose :created_at, format_with: :iso8601, documentation: {
          type: DateTime,
          desc: 'Position create time in iso8601 format.'
        }
        expose :updated_at, format_with: :iso8601, documentation: {
          type: DateTime,
          desc: 'Position update time in iso8601 format.'
        }
        expose :specializations, using: Entities::Specialization, documentation: {
          type: Array,
          desc: 'List of specializations'
        }
      end
    end
  end
end
