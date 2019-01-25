module Cmd
  module UserActionLogger
    module User
      class CreateLog
        include Interactor

        def call
          UserActionLog.create!(context.params)
        end
      end
    end
  end
end
