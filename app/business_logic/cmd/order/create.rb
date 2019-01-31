module Cmd
  module Order
    class Create
      include Interactor

      def call
        result = Cmd::Order::CalculateUrgency.call(params: params)
        @order = profile.orders.create(params.merge(urgency: result.urgency))
        @order.errors.add(:position_search, 'Выберите профессию') unless position
        context.order = @order
        context.fail! unless @order.persisted?
        Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def params
        context.params
      end

      def position
        context.position
      end

      def current_user
        profile.user
      end

      def profile
        context.profile
      end

      def logger_params
        {
          receiver_id: current_user.id,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: 'Создан черновик заявки',
          object_id: @order.id,
          object_type: 'Order'
        }
      end
    end
  end
end
