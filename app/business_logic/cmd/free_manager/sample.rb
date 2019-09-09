module Cmd
  module FreeManager
    class Sample
      include Interactor

      def call
        context.manager = free_managers.sample
      end

      private

      def free_managers
        @hash = Redis::HashKey.new('free_managers')
        @hash.values
      end
    end
  end
end
