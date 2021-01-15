# frozen_string_literal: true

module Cmd
  module Api
    module BotCallback
      class Process
        include Interactor::Organizer

        organize Cmd::Api::BotCallback::Create,
                 Cmd::Api::BotCallback::PushToChannel

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end
