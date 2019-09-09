module Cmd
  module FreeManager
    class Add
      include Interactor

      def call
        free_managers[user.id] = { phone: normalized_phone, guid: guid }.to_json
      end

      private

      def guid
        user.guid
      end

      def user
        context.user
      end

      def normalized_phone
        phone.delete!(' \-+()').sub!(/^./, '8')
      end

      def phone
        context.phone
      end

      def free_managers
        @hash = Redis::HashKey.new('free_managers')
      end
    end
  end
end
