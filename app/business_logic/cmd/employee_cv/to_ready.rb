module Cmd
  module EmployeeCv
    class ToReady
      include Interactor

      delegate :draggable,   to: :context
      delegate :employee_cv, to: :context

      def call
        return reset_reminder if draggable

        context.fail! unless employee_cv.to_ready!
        reset_reminder unless create_reminder?
        Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def current_user
        employee_cv.profile.user
      end

      def create_reminder?
        employee_cv.reminder?
      end

      def reset_reminder
        employee_cv.update_attributes(reminder: nil, comment: nil)
      end

      def logger_params
        {
          login: current_user.email,
          receiver_ids: [current_user.id],
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: "Анкета №#{employee_cv.id} #{employee_cv.name} переведена в готовые",
          object_id: employee_cv.id,
          object_type: 'EmployeeCv',
          employee_cv_id: employee_cv.id
        }
      end
    end
  end
end
