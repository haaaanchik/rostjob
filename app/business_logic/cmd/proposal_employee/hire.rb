module Cmd
  module ProposalEmployee
    class Hire
      include Interactor

      def call
        context.fail! unless candidate.hire!
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def candidate
        context.candidate
      end

      def current_user
        candidate.order.profile.user
      end

      def receiver_ids
        [current_user.id, candidate.profile.user.id]
      end

      def logger_params
        {
          receiver_ids: receiver_ids,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: 'Кандидат нанят',
          object_id: candidate.employee_cv.id,
          object_type: 'EmployeeCv'
        }
      end
    end
  end
end
