module Cmd
  module User
    module Registration
      class CreateLog
        include Interactor

        delegate :user, to: :context

        def call
          Cmd::UserActionLogger::Log.call(params: logger_params)
        end

        private

        def action
          role = user.profile.contractor? ? 'исполнителя' : 'заказчика'

          "Создана учетная запись #{role} #{user.email}"
        end

        def logger_params
          {
            login: user.email,
            receiver_ids: [user.id],
            subject_id: user.id,
            subject_type: 'User',
            subject_role: user.profile.profile_type,
            action: action,
            object_id: user.id,
            object_type: 'User'
          }
        end
      end
    end
  end
end