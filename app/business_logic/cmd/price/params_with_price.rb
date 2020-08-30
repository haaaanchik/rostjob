module Cmd
  module Price
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

      def params
        context.params
      end

      def base_price
        context.only_base
      end

      def position
        context.position
      end

      def title_and_base_price
        params[:base_customer_price] = position&.price_group&.customer_price
        params[:base_contractor_price] = position&.price_group&.contractor_price
      end

      def contractor_prices_equal
        params[:customer_price] = position&.price_group&.customer_price
        params[:contractor_price] = position&.price_group&.contractor_price
        params[:customer_total] = position.price_group.customer_price * params[:number_of_employees].to_i
        params[:contractor_total] = position.price_group.contractor_price * params[:number_of_employees].to_i
      end
    end
  end
end
