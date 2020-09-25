module Cmd
  module User
    class ResetPassword
      include Interactor

      delegate :user_email, to: :context

      def call
        context.fail!(message: 'Пользователь с такой почтой отсутствует') unless user

        if @user.encrypted_password.empty?
          @user.send_confirmation_instructions
          context.message = 'Вам было повторно выслано письмо с инструкцией активации.'
        else
          context.message = 'Вам было отправлено письмо с инструкцией сброса пароля'
          @user.send_reset_password_instructions
        end
      end

      private

      def user
        @user = ::User.find_by(email: user_email)

        context.user = @user
      end
    end
  end
end