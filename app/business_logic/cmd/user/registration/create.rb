module Cmd
  module User
    module Registration
      class Create
        include Interactor

        def call
          @user = ::User.new context.user_params
          context.user = @user
          context.fail! unless @user.save
          Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
        end

        private

        def logger_params
          {
            login: @user,
            receiver_ids: [@user.id],
            subject_id: @user.id,
            subject_type: 'User',
            subject_role: @user.profile ? @user.profile.profile_type : nil,
            action: 'Учетная запись создана',
            object_id: @user.id,
            object_type: 'User'
          }
        end
      end
    end
  end
end
