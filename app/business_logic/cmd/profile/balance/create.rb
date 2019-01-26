module Cmd
  module Profile
    module Balance
      class Create
        include Interactor

        def call
          context.profile.create_balance
        end
      end
    end
  end
end
