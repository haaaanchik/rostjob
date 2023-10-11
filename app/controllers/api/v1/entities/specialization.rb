# frozen_string_literal: true

module Api
  module V1
    module Entities
      class Specialization < Api::V1::Entities::Base
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
        expose :created_at, format_with: :iso8601, documentation: {
          type: DateTime,
          desc: 'Specialization create time in iso8601 format.'
        }
        expose :updated_at, format_with: :iso8601, documentation: {
          type: DateTime,
          desc: 'Specialization update time in iso8601 format.'
        }
      end
    end
  end
end
