module Cmd
  module Ticket
    module Incident
      class Hire
        include Interactor::Organizer

        organize Cmd::ProposalEmployee::Hire,
                 Cmd::Ticket::Incident::Close,
                 Cmd::Ticket::Message::ToCreate

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end
