# frozen_string_literal: true

module Cmd
  module User
    module Registration
      class CreateContractor
        include Interactor::Organizer

        organize Cmd::User::Registration::Create,
                 Cmd::Profile::Create,
                 Cmd::Profile::Balance::Create,
                 Cmd::Profile::Balance::WithdrawalMethod::CreateContractor,
                 Cmd::Profile::Company::PartnerCreate,
                 Cmd::User::Registration::CreateLog

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end
