# frozen_string_literal

module Api
  module Helpers
    module OrdersHelpers
      def published_orders
        Order.published.includes(:city, :position, profile: :company)
      end
    end
  end
end
