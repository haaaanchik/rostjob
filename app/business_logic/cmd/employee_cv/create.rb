module Cmd
  module EmployeeCv
    class Create
      include Interactor

      def call
        @employee_cv = profile.employee_cvs.create params
        context.fail! unless @employee_cv.persisted?
        context.employee_cv = @employee_cv
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
          receiver_id: current_user.id,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: 'Создана анкета',
          object_id: @employee_cv.id,
          object_type: 'EmployeeCv'
        }
      end
    end
  end
end
