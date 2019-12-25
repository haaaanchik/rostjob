module Cmd
  module Service
    class DeactivateAll
      include Interactor

      def call
        service.update_all(active: false)
      end

      private

      def service
        context.service
      end
    end
  end
end
