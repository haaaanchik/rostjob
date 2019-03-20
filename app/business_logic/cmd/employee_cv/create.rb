module Cmd
  module EmployeeCv
    class Create
      include Interactor

      def call
        @employee_cv = profile.employee_cvs.create params
        context.employee_cv = @employee_cv
        context.fail! unless @employee_cv.persisted?
        Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def params
        context.params
      end

      def current_user
        profile.user
      end

      def profile
        context.profile
      end

      def logger_params
        {
          login: current_user.email,
          receiver_ids: [current_user.id],
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: "Создана анкета №#{@employee_cv.id}",
          object_id: @employee_cv.id,
          object_type: 'EmployeeCv',
          employee_cv_id: @employee_cv.id
        }
      end
    end
  end
end
