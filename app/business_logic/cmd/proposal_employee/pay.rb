module Cmd
  module ProposalEmployee
    class Pay
      include Interactor

      def call
        context.fail! unless candidate.to_paid!
        Cmd::UserActionLogger::Log.call(params: customer_params) unless context.log == false
      end

      private

      def candidate
        context.candidate
      end

      def proposal_employee
        candidate
      end

      def customer
        candidate.order.profile.user
      end

      def customer_params
        {
          login: customer.email,
          receiver_ids: [customer.id],
          subject_id: customer.id,
          subject_type: 'User',
          subject_role: customer.profile.profile_type,
          action: "Акт по анкете №#{proposal_employee.employee_cv_id} #{proposal_employee.employee_cv.name} подтвержден",
          object_id: proposal_employee.id,
          object_type: 'ProposalEmployee',
          employee_cv_id: proposal_employee.employee_cv_id,
          order_id: proposal_employee.order_id
        }
      end
    end
  end
end
