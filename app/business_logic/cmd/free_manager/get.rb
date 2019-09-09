module Cmd
  module FreeManager
    class Get
      include Interactor

      def call
        context.manager = free_managers[user_id]
      end

      private

      def user_id
        context.user_id
      end

      def free_managers
        Redis::HashKey.new('free_managers')
      end
    end
  end
end
