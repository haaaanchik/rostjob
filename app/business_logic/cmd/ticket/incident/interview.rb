module Cmd
  module Ticket
    module Incident
      class Interview
        include Interactor::Organizer

        organize Cmd::ProposalEmployee::ToInterview,
                 Cmd::Ticket::Message::Create,
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