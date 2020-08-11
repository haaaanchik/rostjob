module Cmd
  module OrderTemplate
    class FirstOrderTemplateCreate
      include Interactor

      def call
        current_user.update_attribute(:first_order_template_created, true) unless current_user.first_order_template_created
      end

      private

      def current_user
        context.profile.user
      end
    end
  end
end