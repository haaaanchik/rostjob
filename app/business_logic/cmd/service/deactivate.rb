module Cmd
  module Service
    class Deactivate
      include Interactor

      def call
        service.update(active: false)
        context.fail! unless service.persisted?
      end

      private

      def service
        context.service
      end
    end
  end
end
