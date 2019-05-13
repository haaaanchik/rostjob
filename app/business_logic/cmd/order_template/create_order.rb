module Cmd
  module OrderTemplate
    class CreateOrder
      include Interactor

      def call
        profession = Position.find(order_template.position_id)
        customer_total = order_template.customer_price * number_of_employees
        contractor_total = order_template.contractor_price * number_of_employees
        attributes = order_template.attributes
        order_attributes = attributes.merge('id' => nil, 'number_of_employees' => number_of_employees,
                                            'customer_total' => customer_total, 'contractor_total' => contractor_total)
                                     .except('name', 'created_at', 'updated_at')
        result = Cmd::Order::Create.call(profile: profile, params: order_attributes, position: profession)
        result.order.document = order_template.document
        result.order.save
        context.order = result.order
        context.fail! unless result.success?
      end

      private

      def order_template
        context.order_template
      end

      def profile
        order_template.profile
      end

      def number_of_employees
        if context.number_of_employees && !context.number_of_employees.empty?
          context.number_of_employees.to_i
        else
          order_template.number_of_employees
        end
      end
    end
  end
end
