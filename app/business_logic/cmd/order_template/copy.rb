module Cmd
  module OrderTemplate
    class Copy
      include Interactor

      delegate :order_template, to: :context

      def call
        new_order_template = order_template.dup
        new_order_template.name = new_name
        context.fail! unless new_order_template.save
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
