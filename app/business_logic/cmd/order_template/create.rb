module Cmd
  module OrderTemplate
    class Create
      include Interactor

      def call
        result = Cmd::OrderTemplate::ParamsWithPrice.call(order_template_params: params,
                                                          position:              position,
                                                          only_base:             true)
        context.params = result.order_template_params
        @order_template = profile.order_templates.create(params.merge(production_site: production_site))
        @order_template.errors.add(:position_search, 'Выберите профессию') unless position
        context.order_template = @order_template
        context.fail! unless @order_template.persisted?
        current_user.update_attribute(:first_order_template_created, true) unless current_user.first_order_template_created
      end

      private

      def production_site
        context.production_site
      end

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
    end
  end
end
