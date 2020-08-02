module Cmd
  module User
    module Registration
      class Create
        include Interactor

        delegate :user_params, to: :context

        def call
          @user = ::User.new(user_params)
          @user.skip_validation_full_name = true
          context.fail! unless @user.save
          context.user = @user
        end
      end
    end
  end
end
