module Cmd
  module UserActionLogger
    class Log
      include Interactor

      def call
        UserActionLog.create!(context.params)
      end
    end
  end
end
