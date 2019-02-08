module Cmd
  module ProposalEmployee
    class Revoke
      include Interactor

      def call
        context.fail! unless proposal_employee.to_revoked!
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def proposal_employee
        context.proposal_employee
      end

      def current_user
        proposal_employee.employee_cv.profile.user
      end

      def receiver_ids
        [current_user.id, proposal_employee.order.profile.user.id]
      end

      def logger_params
        {
          receiver_ids: receiver_ids,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: 'Анкета отозвана исполнителем',
          object_id: proposal_employee.id,
          object_type: 'EmployeeCv'
        }
      end
    end
  end
end
