module Cmd
  module ProposalEmployee
    class AdminApproval
      include Interactor

      def call
        profile = candidate.profile
        order = candidate.order
        employee_cv = candidate.employee_cv
        amount = order.contractor_price
        description = "Вознаграждение по заявке №#{order.id}, за кандидата №#{candidate.employee_cv_id} #{employee_cv.name}"
        result = profile.balance.deposit(amount, description)
        context.fail! unless result

        proposal_employee.update_attribute(:approved_by_admin, true)
        Cmd::UserActionLogger::Log.call(params: contractor_params) unless context.log == false
      end

      private

      def candidate
        context.candidate
      end

      def proposal_employee
        candidate
      end

      def contractor
        candidate.employee_cv.profile.user
      end

      def contractor_params
        {
          login: contractor.email,
          receiver_ids: [contractor.id],
          subject_id: contractor.id,
          subject_type: 'User',
          subject_role: contractor.profile.profile_type,
          action: "Получено вознаграждение за анкету №#{proposal_employee.employee_cv.id} #{proposal_employee.employee_cv.name}",
          object_id: proposal_employee.id,
          object_type: 'ProposalEmployee',
          employee_cv_id: proposal_employee.employee_cv_id,
          order_id: proposal_employee.order_id
        }
      end
    end
  end
end
