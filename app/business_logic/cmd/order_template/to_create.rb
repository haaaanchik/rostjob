module Cmd
  module OrderTemplate
    class ToCreate
      include Interactor

      delegate :params,          to: :context
      delegate :profile,         to: :context
      delegate :position,        to: :context
      delegate :production_site, to: :context

      def call
        context.params = params.merge(production_site: production_site).except('position_search')
        @order_template = profile.order_templates.create(params.merge(name: set_name))
        @order_template.errors.add(:position_search, 'Выберите профессию') unless position
        context.order_template = @order_template
        context.fail! unless @order_template.persisted?
      end

      private

      def set_name
        "#{ params[:title] } - #{ Date.today.strftime('%d.%m.%Y') }"
      end
    end
  end
end