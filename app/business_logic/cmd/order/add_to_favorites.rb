module Cmd
  module Order
    class AddToFavorites
      include Interactor

      delegate :order,   to: :context
      delegate :profile, to: :context

      def call
        result = order.order_profiles.find_or_create_by!(profile: profile)

        context.fail! unless result
      end
    end
  end
end
