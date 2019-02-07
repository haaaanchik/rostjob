module Cmd
  module OrderTemplate
    class Update
      include Interactor

      def call
        result = Cmd::Order::CalculateUrgency.call(params: params)
        context.fail! unless order_template.update(params.merge(urgency: result.urgency))
        # Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def order_template
        context.order_template
      end

      def params
        context.params
      end

      def current_user
        order.profile.user
      end

      def logger_params
        {
          receiver_id: current_user.id,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: 'Заявка отредактирована',
          object_id: order.id,
          object_type: 'Order'
        }
      end
    end
  end
end
