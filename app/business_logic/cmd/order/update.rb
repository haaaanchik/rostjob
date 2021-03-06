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

          params[:other_info] = params[:other_info].merge('requirements' => { 
            'added_data'=> { 'text' => added_data_text, 'show' => add_data_show },
            'control_aspirant' => { 'text' => ::Order::CONTRACTOR_ASPIRANT_TEXT, 'show' => control_aspirant_show },
            'aspirant' => { 'text' => ::Order::ASPIRANT_TEXT, 'show' => aspirant_show },
            'customer' => { 'text' => ::Order::CUSTOMER_TEXT, 'show' => customer_show }
          })
        when 3
          params[:other_info]['terms'] = order.other_info['terms']
          params[:other_info]['hourly_payment'] = order.other_info['hourly_payment']
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

      def added_data_text
        order.other_info['requirements'] ? order.other_info['requirements']['added_data']['text'] : nil
      end

      def control_aspirant_show
        order.other_info['requirements'] ? order.other_info['requirements']['control_aspirant']['show'] : nil
      end

      def customer_show
        order.other_info['requirements'] ? order.other_info['requirements']['customer']['show'] : nil
      end

      def aspirant_show
        order.other_info['requirements'] ? order.other_info['requirements']['aspirant']['show'] : nil
      end

      def add_data_show
        order.other_info['requirements'] ? order.other_info['requirements']['added_data']['show'] : nil
      end
    end
  end
end
