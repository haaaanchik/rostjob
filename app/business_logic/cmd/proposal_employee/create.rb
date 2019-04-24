module Cmd
  module ProposalEmployee
    class Create
      include Interactor

      def call
        @proposal_employee = profile.proposal_employees.create context.params
        context.proposal_employee = @proposal_employee
        context.fail! unless @proposal_employee.persisted?
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def employee_cv_id
        context.params[:employee_cv_id]
      end

      def employee_cv_name
        ::EmployeeCv.find(employee_cv_id).name
      end

      def order_id
        context.params[:order_id]
      end

      def order_title
        ::Order.find(order_id).title
      end

      def current_user
        profile.user
      end

      def profile
        context.profile
      end

      def receiver_ids
        [current_user.id, @proposal_employee.order.profile.user.id]
      end

      def logger_params
        {
          login: current_user.email,
          receiver_ids: receiver_ids,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: profile.profile_type,
          action: "Анкета №#{employee_cv_id} #{employee_cv_name} отправлена в заявку №#{order_id} #{order_title}",
          object_id: @proposal_employee.id,
          object_type: 'ProposalEmployee',
          order_id: order_id,
          employee_cv_id: employee_cv_id
        }
      end
    end
  end
end
