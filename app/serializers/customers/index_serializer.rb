# frozen_string_literal: true

module Customers
  class IndexSerializer < ::ApplicationSerializer
    attribute :customer_id do |object|
      object.id
    end

    attribute :short_name do |object|
      object.company.short_name
    end

    attribute :logo_url do |object, params|
      "#{params[:base_url]}#{object.photo.url}"
    end

    attribute :orders_count do |object|
      object.o_count
    end
  end
end
