module Cmd
  module Order
    class Move
      include Interactor

      def call
        result = order.update(production_site_id: dst_production_site_id)
        context.fail! unless result
      end

      private

      def dst_production_site_id
        context.dst_production_site_id
      end

      def order
        context.order
      end

      def profile
        order.profile
      end
    end
  end
end
