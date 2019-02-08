module Cmd
  module Order
    class ToPublished
      include Interactor

      def call
        context.fail! unless order.to_published
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
          action: 'Заявка опубликована',
          object_id: order.id,
          object_type: 'Order'
        }
      end
    end
  end
end
