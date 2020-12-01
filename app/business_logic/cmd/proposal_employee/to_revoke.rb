# frozen_string_literal: true

module Cmd
  module ProposalEmployee
    class ToRevoke
      include Interactor

      delegate :user,              to: :context
      delegate :proposal_employee, to: :context

      def call
        context.fail! unless proposal_employee.to_revoked!

        set_contexts
      end

      private

      def set_contexts
        context.employee_cv = proposal_employee.employee_cv
        context.order_profile = proposal_employee.order.profile
        context.candidate = proposal_employee
      end
    end
  end
end
