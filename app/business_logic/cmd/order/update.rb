module Cmd
  module Order
    class Update
      include Interactor

      def call
        result = Cmd::Order::CalculateUrgency.call(params: params)
        set_other_info
        context.fail! unless order.update(params.merge(urgency: result.urgency))
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

      def set_other_info
        case order.creation_step
        when 2
          params[:other_info]['remark'] = order.other_info['remark']
          params[:other_info]['added_data'] = order.other_info['added_data']
          params[:other_info]['control_aspirant'] = order.other_info['control_aspirant']
          params[:other_info]['informate_aspirant'] = order.other_info['informate_aspirant']
          params[:other_info]['informate_customer'] = order.other_info['informate_customer']
        when 3
          params[:other_info]['terms'] = order.other_info['terms']
        else
          order
        end
      end

      def logger_params
        {
          login: current_user.email,
          receiver_ids: [current_user.id],
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: "Заявка №#{order.id} #{order.title} отредактирована",
          object_id: order.id,
          object_type: 'Order',
          order_id: order.id
        }
      end
    end
  end
end
