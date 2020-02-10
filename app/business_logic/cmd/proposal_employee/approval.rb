module Cmd
  module ProposalEmployee
    class Approval
      include Interactor

      def call
        context.fail! unless candidate.to_approved!
        Cmd::UserActionLogger::Log.call(params: customer_params)
      end

      private

      def candidate
        context.candidate
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
          action: "Условие по анкете №#{candidate.employee_cv_id} #{candidate.employee_cv.name} выполнено",
          object_id: candidate.id,
          object_type: 'ProposalEmployee',
          employee_cv_id: candidate.employee_cv_id,
          order_id: candidate.order_id
        }
      end
    end
  end
end
