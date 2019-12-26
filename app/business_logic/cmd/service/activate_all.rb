module Cmd
  module Service
    class ActivateAll
      include Interactor

      def call
        service.update_all(active: true)
      end

      private

      def service
        context.service
      end
    end
  end
end
