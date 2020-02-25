module Cmd
  module OrderTemplate
    class CreateOrder
      include Interactor

      def call
        profession = Position.find(order_template.position_id)
        customer_total = order_template.customer_price
        contractor_total = order_template.contractor_price
        attributes = order_template.attributes
        order_attributes = attributes.merge('customer_total' => customer_total, 'contractor_total' => contractor_total)
                                     .except('id', 'name', 'created_at', 'updated_at', 'template_saved')
        result = Cmd::Order::Create.call(profile: profile, params: order_attributes, position: profession)
        result.order.document = order_template.document
        result.order.save
        context.order = result.order
        context.fail! unless result.success?
        order_template.destroy unless order_template.template_saved
      end

      private

      def order_template
        context.order_template
      end

      def profile
        order_template.profile
      end
    end
  end
end
