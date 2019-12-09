module Cmd
  module ProposalEmployee
    class Revoke
      include Interactor

      def call
        context.fail! unless proposal_employee.to_revoked!
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
        proposal_employee.incidents.opened.map(&:to_closed!) if proposal_employee.incidents.opened.any?
        Cmd::EmployeeCv::ToReady.call(employee_cv: proposal_employee.employee_cv)
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
          login: current_user.email,
          receiver_ids: receiver_ids,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: "Анкета №#{proposal_employee.employee_cv.id} #{proposal_employee.employee_cv.name} отозвана исполнителем",
          object_id: proposal_employee.id,
          object_type: 'ProposalEmployee',
          order_id: proposal_employee.order_id,
          employee_cv_id: proposal_employee.employee_cv_id
        }
      end
    end
  end
end
