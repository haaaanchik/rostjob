# frozen_string_literal: true

module Api
  class Base < Grape::API
    helpers Api::Helpers::OrdersHelpers
    mount V1::Root
  end
end
