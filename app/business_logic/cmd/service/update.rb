module Cmd
  module Service
    class Update
      include Interactor

      def call
        context.fail! unless service.update(params)
      end

      private

      def service
        context.service
      end

      def params
        context.params
      end
    end
  end
end
