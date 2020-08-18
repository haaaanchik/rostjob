module Cmd
  module ProposalEmployee
    class ToRevoke
      include Interactor

      delegate :user, to: :context
      delegate :proposal_employee, to: :context

      def call
        context.fail! unless proposal_employee.to_revoked!

        set_contexts
      end

      private

      def set_contexts
        context.employee_cv = context.proposal_employee.employee_cv
        context.order_profile = context.proposal_employee.order.profile
        context.candidate = context.proposal_employee
      end
    end
  end
end