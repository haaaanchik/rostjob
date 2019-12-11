module Cmd
  module User
    module Registration
      class Update
        include Interactor

        def call
          user_params.each do |k, v|
            user.update_attribute(k, v)
          end
          Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
        end

        private

        def user
          context.user
        end

        def user_params
          context.params
        end

        def logger_params
          {
            receiver_ids: [user.id],
            subject_id: user.id,
            subject_type: 'User',
            subject_role: user.profile ? user.profile.profile_type : nil,
            action: "Учетная запись #{user.email} отредактирована",
            object_id: @user.id,
            object_type: 'User'
          }
        end
      end
    end
  end
end
