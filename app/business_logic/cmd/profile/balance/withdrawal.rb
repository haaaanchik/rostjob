module Cmd
  module Profile
    module Balance
      class Withdrawal
        include Interactor::Organizer

        organize Cmd::Invoice::Create,
                 Cmd::Profile::Balance::ToWithdrawal,
                 Cmd::ProposalEmployee::ToInvoices

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end
