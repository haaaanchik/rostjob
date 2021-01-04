module Cmd
  module ProposalEmployee
    class Pay
      include Interactor::Organizer

      organize Cmd::ProposalEmployee::ToPay,
               Cmd::Rating::Update,
               Cmd::UserActionLogger::ProposalEmployee::CreateLogsCasePay

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        end
      end
    end
  end
end
