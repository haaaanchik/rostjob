module Cmd
  module ProposalEmployee
    class Revoke
      include Interactor::Organizer

      organize Cmd::ProposalEmployee::ToRevoke,
               Cmd::EmployeeCv::ToReady,
               Cmd::Rating::Update,
               Cmd::UserActionLogger::ProposalEmployee::CreateLoginCaseRevoke,
               Cmd::NotifyMail::ProposalEmployee::Revoke

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        end
      end
    end
  end
end
