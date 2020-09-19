module Cmd
  module OrderTemplate
    class Copy
      include Interactor

      delegate :order_template, to: :context

      def call
        attributes = order_template.attributes
        @order_template = profile.order_templates.create(attributes.merge('id' => nil, 'name' => new_name))
        @order_template.document = order_template.document
        @order_template.save
        context.double_order_template = @order_template
        context.fail! unless @order_template.persisted?
      end

      private

      def new_name
        "Копия #{order_template.name}"
      end

      def profile
        order_template.profile
      end
    end
  end
end
