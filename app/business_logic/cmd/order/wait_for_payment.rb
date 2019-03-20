module Cmd
  module Order
    class WaitForPayment
      include Interactor

      def call
        context.fail! unless order.to_waiting_for_payment
        Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def order
        context.order
      end

      def params
        context.params
      end

      def current_user
        order.profile.user
      end

      def logger_params
        {
          receiver_ids: [current_user.id],
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: "Статус заявки №#{order.id} изменён на: 'Ожидание оплаты'",
          object_id: order.id,
          object_type: 'Order'
        }
      end
    end
  end
end
