module Cmd
  module Profile
    module Balance
      class Create
        include Interactor

        delegate :profile, to: :context

        def call
          context.fail!(message: 'Не удалось создать счёт для профиля') unless profile.create_balance
        end
      end
    end
  end
end
