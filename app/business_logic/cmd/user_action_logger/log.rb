module Cmd
  module UserActionLogger
    class Log
      include Interactor

      def call
        UserActionLog.create!(context.params) if Rails.configuration.user_action_log
      end
    end
  end
end
