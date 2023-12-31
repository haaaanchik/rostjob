module Cmd
  module Ticket
    module Message
      class Create
        include Interactor::Organizer

        organize Cmd::Ticket::ToUpdateWaiting,
                 Cmd::Ticket::Message::ToCreate,
                 Cmd::NotifyMail::Ticket::Message

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end
