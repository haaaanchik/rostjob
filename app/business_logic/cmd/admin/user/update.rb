module Cmd
  module Admin
    module User
      class Update
        include Interactor

        delegate :user, to: :context
        delegate :user_params, to: :context
        delegate :balance_amount, to: :context

        def call
          check_password_field

          context.fail! unless user.update(user_params)

          return if balance_amount == user.balance.amount

          user.balance.update_amount(balance_amount)
        end

        private

        def check_password_field
          return unless user_params[:password].blank?

          user.skip_validation_password = true
          user_params.delete(:password)
          user_params.delete(:password_confirmation)
        end
      end
    end
  end
end