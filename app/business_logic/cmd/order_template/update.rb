module Cmd
  module OrderTemplate
    class Update
      include Interactor

      def call
        if [1, 2].include?(order_template.creation_step.to_i)
          params_with_price = Cmd::Price::ParamsWithPrice.call(params:     params,
                                                               position:   position,
                                                               only_base:  false)
          context.params = params_with_price.params
        end
        set_other_info
        result = Cmd::Order::CalculateUrgency.call(params: params)
        context.fail! unless order_template.update(params.merge(urgency_level: result.urgency))
      end

      private

      def order_template
        context.order_template
      end

      def position
        context.position
      end

      def params
        context.params
      end

      def current_user
        order.profile.user
      end

      def set_other_info
        case order_template.creation_step
        when 2
          params[:other_info]['remark'] = order_template.other_info['remark']

          params[:other_info] = params[:other_info].merge('requirements' => { 'added_data'=> { 'text' => added_data_text },
            'control_aspirant' => { 'text' => ::Order::CONTRACTOR_ASPIRANT_TEXT, 'show' => control_aspirant_show },
            'aspirant' => { 'text' => ::Order::ASPIRANT_TEXT, 'show' => aspirant_show },
            'customer' => { 'text' => ::Order::CUSTOMER_TEXT, 'show' => customer_show }
          })
        when 3
          params[:other_info]['terms'] = order_template.other_info['terms']
        else
          order_template
        end
      end

      def added_data_text
        order_template.other_info['requirements'] ? order_template.other_info['requirements']['added_data']['text'] : nil
      end

      def control_aspirant_show
        order_template.other_info['requirements'] ? order_template.other_info['requirements']['control_aspirant']['show'] : nil
      end

      def customer_show
        order_template.other_info['requirements'] ? order_template.other_info['requirements']['customer']['show'] : nil
      end

      def aspirant_show
        order_template.other_info['requirements'] ? order_template.other_info['requirements']['aspirant']['show'] : nil
      end
    end
  end
end
