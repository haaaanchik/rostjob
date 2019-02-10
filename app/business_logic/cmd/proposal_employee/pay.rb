module Cmd
  module ProposalEmployee
    class Pay
      include Interactor

      def call
        proposal = candidate.proposal
        profile = proposal.profile
        order = proposal.order
        amount = order.contractor_price
        result = profile.balance.deposit(amount, "Вознаграждение по заявке №#{order.id}")
        context.fail! unless result
        candidate.to_paid!
        Cmd::UserActionLogger::Log.call(params: contractor_params) unless context.log == false
        Cmd::UserActionLogger::Log.call(params: customer_params) unless context.log == false
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

      def customer
        candidate.order.profile.user
      end

      def contractor_params
        {
          receiver_ids: [contractor.id],
          subject_id: contractor.id,
          subject_type: 'User',
          subject_role: contractor.profile.profile_type,
          action: 'Получено вознаграждение',
          object_id: proposal_employee.id,
          object_type: 'ProposalEmployee'
        }
      end

      def customer_params
        {
          receiver_ids: [customer.id],
          subject_id: customer.id,
          subject_type: 'User',
          subject_role: customer.profile.profile_type,
          action: 'Условие выполнено',
          object_id: proposal_employee.id,
          object_type: 'ProposalEmployee'
        }
      end
    end
  end
end
