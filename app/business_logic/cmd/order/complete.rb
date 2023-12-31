module Cmd
  module Order
    class Complete
      include Interactor

      def call
        context.fail! unless order.to_completed
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

      def receiver_ids
        [current_user.id] + order.profiles.map(&:user).pluck(:id)
      end

      def logger_params
        {
          login: current_user.email,
          receiver_ids: receiver_ids,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: "Заявка №#{order.id} #{order.title} завершена",
          object_id: order.id,
          object_type: 'Order',
          order_id: order.id
        }
      end
    end
  end
end
