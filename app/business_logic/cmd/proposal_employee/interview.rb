module Cmd
  module ProposalEmployee
    class Interview
      include Interactor::Organizer

      organize Cmd::ProposalEmployee::ToInterview,
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