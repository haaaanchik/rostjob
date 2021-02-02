# frozen_string_literal: true

module Cmd
  module ProposalEmployee
    class Hire
      include Interactor::Organizer

      organize Cmd::Order::AddToNumberOfEmployees,
               Cmd::ProposalEmployee::ToHire,
               Cmd::UserActionLogger::ProposalEmployee::CreateLogsCaseHire,
               Cmd::NotifyMail::ProposalEmployee::Hire

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        end
      end
    end
  end
end
