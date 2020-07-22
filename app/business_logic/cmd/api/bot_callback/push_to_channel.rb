module Cmd
  module Api
    module BotCallback
      class PushToChannel
        include Interactor

        delegate :profile_id, to: :context
        delegate :input_params, to: :context

        def call
          ActionCable.server.broadcast("bot_channel_#{profile_id}",
                                       new_empl_cv_url: new_empl_cv_url)
        end

        private

        def new_empl_cv_url
          '/profile/employee_cvs?modal=new_empl&name='+
            input_params[:name]+
            '&phone_number='+
            input_params[:phone]
        end
      end
    end
  end
end
