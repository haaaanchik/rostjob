module Cmd
  module OrderTemplate
    class Create
      include Interactor

      def call
        result = Cmd::Order::CalculateUrgency.call(params: params)
        @order_template = profile.order_templates.create(params.merge(urgency: result.urgency))
        @order_template.errors.add(:position_search, 'Выберите профессию') unless position
        context.order_template = @order_template
        context.fail! unless @order_template.persisted?
        # Cmd::UserActionLogger::Log.call(params: logger_params)
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
          # login: current_user.email,
          # receiver_id: current_user.id,
          # subject_id: current_user.id,
          # subject_type: 'User',
          # subject_role: current_user.profile.profile_type,
          # action: 'Создан черновик заявки',
          # object_id: @order.id,
          # object_type: 'Order',
          # order_id: @order.id
        }
      end
    end
  end
end
