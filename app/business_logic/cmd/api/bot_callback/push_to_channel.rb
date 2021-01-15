# frozen_string_literal: true

module Cmd
  module Api
    module BotCallback
      class PushToChannel
        include Interactor

        delegate :name, to: :context
        delegate :phone, to: :context
        delegate :profile_id, to: :context

        def call
          ActionCable.server.broadcast("bot_channel_#{profile_id}",
                                       new_empl_cv_url: new_empl_cv_url)
        end

        private

        def new_empl_cv_url
          '/profile/employee_cvs?modal=new_empl&name='+name+
            '&phone_number='+phone
        end
      end
    end
  end
end
