module Cmd
  module ProposalEmployee
    class CorrectInterviewDate
      include Interactor

      delegate :interview_date, to: :context
      delegate :proposal_employee, to: :context

      def call
        context.fail! unless proposal_employee.update(interview_date: interview_date)
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def profile
        proposal_employee.profile
      end

      def current_user
        profile.user
      end

      def employee_cv_id
        proposal_employee.employee_cv_id
      end

      def order_id
        proposal_employee.order_id
      end

      def employee_cv_name
        ::EmployeeCv.find(employee_cv_id).name
      end

      def order_title
        ::Order.find(order_id).title
      end

      def receiver_ids
        [current_user.id, proposal_employee.order.profile.user.id]
      end

      def logger_params
        {
          login: current_user.email,
          receiver_ids: receiver_ids,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: profile.profile_type,
          action: "Скорректирована дата собеседования для анкеты №#{employee_cv_id} #{employee_cv_name} в заявке №#{order_id} #{order_title}",
          object_id: proposal_employee.id,
          object_type: 'ProposalEmployee',
          order_id: order_id,
          employee_cv_id: employee_cv_id
        }
      end
    end
  end
end
