# frozen_string_literal: true

module Api
  module V1
    module Entities
      class Specialization < Api::V1::Entities::Base
        expose :title,
               documentation: {
                 desc: 'Specialization title.',
                 type: String
               }
        expose(:image_url,
               documentation: {
                 desc: 'Specialization image.',
                 type: String
               }
        ) do |specialization, options|
          "#{options[:base_url]}#{specialization.image.url}"
        end

        expose :positions,
               documentation: {
                 desc: 'Positions array.',
                 type: Array
               }, using: Entities::Position

      end
    end
  end
end




