module Cmd
  module Admin
    module User
      class Update
        include Interactor

        delegate :user, to: :context

        def call
          check_password_field

          context.fail! unless user.update(params)
        end

        private

        def params
          @params ||= context.params
        end

        def check_password_field
          return unless params[:password].blank?

          user.skip_validation_password = true
          params.delete(:password)
          params.delete(:password_confirmation)
        end
      end
    end
  end
end