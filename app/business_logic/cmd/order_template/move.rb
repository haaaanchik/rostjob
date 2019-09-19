module Cmd
  module OrderTemplate
    class Move
      include Interactor

      def call
        result = order_template.update(production_site_id: dst_production_site_id)
        context.fail! unless result
      end

      private

      def dst_production_site_id
        context.dst_production_site_id
      end

      def order_template
        context.order_template
      end

      def profile
        order_template.profile
      end
    end
  end
end
