module Cmd
  module ProposalEmployee
    class Pay
      include Interactor

      def call
        context.fail! unless candidate.to_paid!
        Cmd::UserActionLogger::Log.call(params: customer_params) unless context.log == false
        calculate_deal_counter
        Cmd::Rating::Update.call(order_profile: order_profile, candidate: candidate)
      end

      private

      def candidate
        context.candidate
      end

      def order_profile
        candidate.order.profile
      end

      def proposal_employee
        candidate
      end

      def customer
        candidate.order.profile.user
      end

      def calculate_deal_counter
        order_profile.increment!(:deal_counter)
        candidate.profile.increment!(:deal_counter)
        candidate.order.production_site.increment!(:deal_counter)
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
