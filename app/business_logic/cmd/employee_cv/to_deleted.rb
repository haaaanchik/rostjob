module Cmd
  module EmployeeCv
    class ToDeleted
      include Interactor

      def call
        context.fail! unless employee_cv.to_deleted!
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
          login: current_user.email,
          receiver_ids: [current_user.id],
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: "Анкета №#{employee_cv.id} #{employee_cv.name} перемещена в удалённые",
          object_id: employee_cv.id,
          object_type: 'EmployeeCv',
          employee_cv_id: employee_cv.id
        }
      end
    end
  end
end
