module Cmd
  module OrderTemplate
    class Copy
      include Interactor

      def call
        attributes = order_template.attributes
        @order_template = profile.order_templates.create(attributes.merge('id' => nil, 'name' => new_name))
        context.double_order_template = @order_template
        context.fail! unless @order_template.persisted?
      end

      private

      def new_name
        "Копия #{order_template.name}"
      end

      def order_template
        context.order_template
      end

      def profile
        order_template.profile
      end
    end
  end
end
