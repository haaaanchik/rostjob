# frozen_string_literal: true

module Api
  module V1
    module Entities
      module Profiles
        class Customer < Api::V1::Entities::Base
          expose :id,
                 documentation: {
                   desc: 'Customer id.',
                   type: Integer
                 }

          expose(:short_name,
                 documentation: {
                   desc: 'Customer company short_name.',
                   type: String
                 }
          ) do |profile|
            profile.company.short_name
          end

          expose(:logo_url,
                 documentation: {
                   desc: 'Customer logo.',
                   type: String
                 }
          ) do |profile, options|
            "#{options[:base_url]}#{profile.photo.url}"
          end

          expose(:company_description,
                 documentation: {
                   desc: 'Some information about customer.',
                   type: String
                 }
          ) do |profile|
            profile.company.description
          end

          expose(:city,
                 documentation: {
                   desc: 'Address customer company.',
                   type: String
                 }
          ) do |profile|
            profile.company.address
          end

          expose(:published_orders_count,
                documentation: {
                  desc: 'count published orders the customer',
                  type: String
                }
          ) do |profile|
            profile.orders.published.count
          end
        end
      end
    end
  end
end
