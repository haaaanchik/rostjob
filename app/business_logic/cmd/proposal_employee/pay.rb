module Cmd
  module ProposalEmployee
    class Pay
      include Interactor

      def call
        profile = candidate.profile
        order = candidate.order
        employee_cv = candidate.employee_cv
        amount = order.contractor_price
        description = "Вознаграждение по заявке №#{order.id}, за кандидата №#{candidate.employee_cv_id} #{employee_cv.name}"
        result = profile.balance.deposit(amount, description)
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

      def customer_params
        {
          login: customer.email,
          receiver_ids: [customer.id],
          subject_id: customer.id,
          subject_type: 'User',
          subject_role: customer.profile.profile_type,
          action: "Условие по анкете №#{proposal_employee.employee_cv_id} #{proposal_employee.employee_cv.name} выполнено",
          object_id: proposal_employee.id,
          object_type: 'ProposalEmployee',
          employee_cv_id: proposal_employee.employee_cv_id,
          order_id: proposal_employee.order_id
        }
      end
    end
  end
end
