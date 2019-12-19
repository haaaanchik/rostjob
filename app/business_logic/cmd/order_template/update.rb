module Cmd
  module OrderTemplate
    class Update
      include Interactor

      def call
        if [1, 2].include?(order_template.template_creation_step.to_i)
          params_with_price = Cmd::OrderTemplate::ParamsWithPrice.call(order_template_params: params,
                                                                       position:              position,
                                                                       only_base:             false)
          context.params = params_with_price.order_template_params
        end
        result = Cmd::Order::CalculateUrgency.call(params: params)
        context.fail! unless order_template.update(params.merge(urgency_level: result.urgency))
      end

      private

      def order_template
        context.order_template
      end

      def position
        context.position
      end

      def params
        context.params
      end

      def current_user
        order.profile.user
      end
    end
  end
end
