module Cmd
  module FreeManager
    class Process
      include Interactor::Organizer

      organize Cmd::Api::AuthenticateUser, Cmd::FreeManager::Sample
    end
  end
end
