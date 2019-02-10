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
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def candidate
        context.candidate
      end

      def proposal_employee
        candidate
      end

      def current_user
        candidate.employee_cv.profile.user
      end

      def receiver_ids
        [current_user.id]
      end

      def logger_params
        {
          receiver_ids: receiver_ids,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: 'Получено вознаграждение',
          object_id: proposal_employee.id,
          object_type: 'ProposalEmployee'
        }
      end
    end
  end
end
