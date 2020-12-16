module Cmd
  module Ticket
    module Incident
      class Inbox
        include Interactor::Organizer

        organize Cmd::ProposalEmployee::ToInbox,
                 Cmd::Ticket::Message::ToCreate,
                 Cmd::Ticket::Incident::Close

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end