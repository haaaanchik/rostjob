module Cmd
  module Service
    class Activate
      include Interactor

      def call
        service.update(active: true)
        context.fail! unless service.persisted?
      end

      private

      def service
        context.service
      end
    end
  end
end
