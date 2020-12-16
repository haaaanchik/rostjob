module Cmd
  module Ticket
    module Incident
      class Interview
        include Interactor::Organizer

        organize Cmd::ProposalEmployee::ToInterview,
                 Cmd::Ticket::Message::ToCreate,
                 Cmd::Ticket::Incident::Close,
                 Cmd::UserActionLogger::ProposalEmployee::Interview::ByUser,
                 Cmd::NotifyMail::ProposalEmployee::Interview

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end
