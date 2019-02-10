module Cmd
  module EmployeeCv
    class Update
      include Interactor

      def call
        context.fail! unless employee_cv.update(params)
        Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def employee_cv
        context.employee_cv
      end

      def params
        context.params
      end

      def current_user
        employee_cv.profile.user
      end

      def logger_params
        {
          receiver_ids: [current_user.id],
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: 'Анкета отредактирована',
          object_id: employee_cv.id,
          object_type: 'EmployeeCv'
        }
      end
    end
  end
end
