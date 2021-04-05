module Cmd
  module ProposalEmployee
    class ToInterview
      include Interactor

      delegate :proposal_employee, to: :context
      delegate :log, to: :context

      def call
        context.fail! unless proposal_employee.update(interview_date: interview_date)
        context.fail!(errors: 'Не удалось назначить интервью') unless proposal_employee.to_interview!
      end

      private

      def interview_date
        Date.parse(context.interview_date)
      end

      def current_user
        proposal_employee.order.profile.user
      end

      def receiver_ids
        [current_user.id, proposal_employee.profile.user.id]
      end

      def logger_params
        {
          login: current_user.email,
          receiver_ids: receiver_ids,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: "Кандидату #{proposal_employee.employee_cv.name} с анкетой №#{proposal_employee.employee_cv.id} назначена дата собеседования #{proposal_employee.interview_date.strftime('%d.%m.%Y')}",
          object_id: proposal_employee.employee_cv.id,
          object_type: 'EmployeeCv',
          order_id: proposal_employee.order_id,
          employee_cv_id: proposal_employee.employee_cv_id
        }
      end
    end
  end
end
