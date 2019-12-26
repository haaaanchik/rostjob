module Cmd
  module Order
    class ToModeration
      include Interactor

      def call
        order.update_attributes(params)
        context.fail! unless order.to_moderation
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
          login: current_user.email,
          receiver_ids: [current_user.id],
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: "Заявка №#{order.id} #{order.title} на модерации",
          object_id: order.id,
          object_type: 'Order',
          order_id: order.id
        }
      end
    end
  end
end
