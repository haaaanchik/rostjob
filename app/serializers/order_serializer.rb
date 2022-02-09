# frozen_string_literal: true


class OrderSerializer < ApplicationSerializer
  attribute :id, :title, :salary, :skill, :other_info

  attribute :company_id do |object|
    object.profile_id
  end

  attribute :company_short_name do |object|
    object.profile.company.short_name
  end

  attribute :company_logo do |object, params|
    "#{params[:base_url]}#{object.profile.image_url}"
  end

  attribute :company_description do |object|
    object.profile.company.description
  end

  attribute :city do |object|
    object.city.name
  end

  attribute :shift_method do |object|
    object.shift_method ? 1 : 0
  end

  attribute :order_specializations do |object|
    object.position.specializations.map(&:title)
  end

  attribute :food_nutrition do |object|
    object.food_nutrition ? 1 : 0
  end

  attribute :housing do |object|
    object.housing ? 1 : 0
  end

  attribute :without_experience do |object|
    object.customer_price <= 8000 ? 1 : 0
  end

  attribute :published_at do |object|
    object.created_at.strftime('%e %B %Y')
  end
end
