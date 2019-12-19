module Cmd
  module OrderTemplate
    class ParamsWithPrice
      include Interactor

      def call
        if position
          title_and_base_price
          return if base_price
          contractor_prices_equal
        end
      end

      private

      def order_template
        context.order_template_params
      end

      def base_price
        context.only_base
      end

      def position
        context.position
      end

      def title_and_base_price
        order_template[:base_customer_price] = position&.price_group&.customer_price
        order_template[:base_contractor_price] = position&.price_group&.contractor_price
        order_template[:title] = position&.title
      end

      def contractor_prices_equal
        order_template[:customer_price] = position&.price_group&.customer_price
        order_template[:contractor_price] = position&.price_group&.contractor_price
        order_template[:customer_total] = position.price_group.customer_price
        order_template[:contractor_total] = position.price_group.contractor_price
      end
    end
  end
end
