# frozen_string_literal: true

module Cmd
  module ProposalEmployee
    class AdminApproval
      include Interactor::Organizer

      organize Cmd::ProposalEmployee::Approve::ToApprove,
               Cmd::ProposalEmployee::Approve::UpdateDeposit,
               Cmd::NotifyMail::ProposalEmployee::Pay

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        end
      end
    end
  end
end
