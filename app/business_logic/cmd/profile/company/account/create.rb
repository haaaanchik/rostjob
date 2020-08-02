module Cmd
  module Profile
    module Company
      module Account
        class Create
          include Interactor

          delegate :profile, to: :context

          def call
            account = profile.company.accounts.build
            account.save(validate: false)
            context.account = account
          end
        end
      end
    end
  end
end