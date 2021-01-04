module Cmd
  module Ticket
    module Incident
      class Revoke
        include Interactor::Organizer

        organize Cmd::ProposalEmployee::ToRevoke,
                 Cmd::EmployeeCv::ToReady,
                 Cmd::Rating::Update,
                 Cmd::Ticket::Incident::Close,
                 Cmd::Ticket::Message::ToCreate,
                 Cmd::UserActionLogger::ProposalEmployee::CreateLogsCaseRevoke,
                 Cmd::NotifyMail::ProposalEmployee::Revoke

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end
