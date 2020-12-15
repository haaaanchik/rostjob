module Cmd
  module Admin
    module Ticket
      module Incident
        class Interview
          include Interactor::Organizer

          organize Cmd::ProposalEmployee::ToInterview,
                   Cmd::Ticket::Incident::Close,
                   Cmd::Ticket::Message::Create,
                   Cmd::UserActionLogger::ProposalEmployee::Interview::ByStaffer,
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
end