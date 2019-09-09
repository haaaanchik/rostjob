module Cmd
  module FreeManager
    class Remove
      include Interactor

      def call
        free_manages.delete(user_id)
      end

      private

      def user_id
        context.user_id
      end

      def free_manages
        @hash = Redis::HashKey.new('free_managers')
      end
    end
  end
end
