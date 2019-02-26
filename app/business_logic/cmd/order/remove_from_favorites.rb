module Cmd
  module Order
    class RemoveFromFavorites
      include Interactor

      def call
        order_profile = OrderProfile.find_by(order: order, profile: profile)
        context.fail! unless order_profile
        order_profile.destroy
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
