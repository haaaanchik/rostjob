module Cmd
  module Order
    class AddToFavorites
      include Interactor

      def call
        result = order.order_profiles.find_or_create_by! profile: profile
        context.fail! unless result
      end

      private

      def order
        context.order
      end

      def profile
        context.profile
      end
    end
  end
end
