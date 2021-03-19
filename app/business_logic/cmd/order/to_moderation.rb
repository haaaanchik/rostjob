module Cmd
  module Order
    class ToModeration
      include Interactor

      delegate :order,  to: :context
      delegate :params, to: :context

      def call
        update_order
        context.fail! unless order.to_moderation

        Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def update_order
        order.update(customer_total: count_customer_total,
                     number_of_employees: params[:number_of_employees])
      end

      def count_customer_total
        params[:number_of_employees].to_i * order.customer_price
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
