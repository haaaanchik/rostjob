module Cmd
  module User
    module Registration
      class CreateCustomer
        include Interactor::Organizer

        organize Cmd::User::Registration::Create,
                 Cmd::Profile::Create,
                 Cmd::Profile::Balance::Create,
                 Cmd::Profile::Company::Create,
                 Cmd::Profile::Company::Account::Create,
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
