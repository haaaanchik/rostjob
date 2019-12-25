module Cmd
  module Service
    class Copy
      include Interactor

      def call
        attributes = service.attributes
        attributes.delete('active')
        double = create_model.create(attributes.merge('id' => nil, 'title' => new_title))
        context.double = double
        context.fail! unless double.persisted?
        context.double.update(active: true) if service.active.none?
        context.fail! unless double.persisted?
      end

      private

      def new_title
        "Копия #{service.title}"
      end

      def service
        context.service
      end

      def service_klass
        context.service_klass
      end

      def create_model
        service.kind_of?(::SuperJob::Query) ? ::SuperJob::Config.config.queries : service_klass
      end
    end
  end
end
