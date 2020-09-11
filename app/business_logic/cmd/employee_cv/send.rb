module Cmd
  module EmployeeCv
    class Send
      include Interactor::Organizer

      organize Cmd::EmployeeCv::Create,
               Cmd::EmployeeCv::ToReady,
               Cmd::Order::AddToFavorites,
               Cmd::ProposalEmployee::ToCreate,
               Cmd::EmployeeCv::ToSent,
               Cmd::NotifyMail::ProposalEmployee::Inbox

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        end
      end
    end
  end
end