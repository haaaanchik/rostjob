module Cmd
  module ProposalEmployee
    class Create
      include Interactor

      def call
        @proposal_employee = profile.proposal_employees.create order_id: order_id, employee_cv: employee_cv
        context.fail! unless @proposal_employee.persisted?
        context.proposal_employee = @proposal_employee
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def employee_cv
        context.employee_cv
      end

      def order_id
        context.order_id
      end

      def current_user
        profile.user
      end

      def profile
        employee_cv.profile
      end

      def receiver_ids
        [current_user.id, @proposal_employee.order.profile.user.id]
      end

      def logger_params
        {
          receiver_ids: receiver_ids,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: 'Анкета отправлена',
          object_id: @proposal_employee.id,
          object_type: 'ProposalEmployee'
        }
      end
    end
  end
end
