module Cmd
  module Api
    module BotCallback
      class Process
        include Interactor::Organizer

        organize Cmd::Api::AuthenticateUser, Cmd::Api::BotCallback::ValidateRequest,
                 Cmd::Api::BotCallback::Create
      end
    end
  end
end
