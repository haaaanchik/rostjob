# frozen_string_literal: true

module Customers
  class ShowSerializer < ::ApplicationSerializer
    attributes :id

    attribute :short_name do |object|
      object.company.short_name
    end

    attribute :logo_url do |object, params|
      "#{params[:base_url]}#{object.photo.url}"
    end

    attribute :company_description do |object|
      object.company.description
    end

    attribute :city do |object|
      object.company.address
    end

    attributes :orders do |object, params|
      orders = PublishedOrdersSpecification.to_scope.where(profile_id: object.id)
      ::OrderSerializer.serialized_collection(orders, params)
    end
  end
end
