module Cmd
  module Service
    class Create
      include Interactor

      def call
        service = create_model.create(params)
        context.service = service
        context.fail! unless service.persisted?
        context.service.update(active: true) if service_klass.active.none?
        context.fail! unless service.persisted?
      end

      private

      def params
        context.params
      end

      def service_klass
        context.service_klass
      end

      def create_model
        service_klass == ::SuperJob::Query ? ::SuperJob::Config.config.queries : service_klass
      end
    end
  end
end
