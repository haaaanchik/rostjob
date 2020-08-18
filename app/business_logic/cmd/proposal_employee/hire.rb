module Cmd
  module ProposalEmployee
    class Hire
      include Interactor

      delegate :candidate, to: :context
      delegate :log, to: :context

      def call
        context.fail! if hiring_date.nil?

        candidate.update(hiring_date: hiring_date, warranty_date: Holiday.warranty_date(hiring_date, order.warranty_period))
        candidate.hire!

        # order.complete! if order.reload.candidates.hired.count == order.number_of_employees
        Cmd::UserActionLogger::Log.call(params: logger_params) if log

        mail_for_contractor_hired
      end

      private

      def order
        candidate.order
      end

      def mail_for_contractor_hired
        Cmd::NotifyMail::ProposalEmployee::Hire.call(proposal_employee: candidate)
      end

      def hiring_date
        Date.parse(context.hiring_date)
      end

      def current_user
        candidate.order.profile.user
      end

      def receiver_ids
        [current_user.id, candidate.profile.user.id]
      end

      def logger_params
        {
          login: current_user.email,
          receiver_ids: receiver_ids,
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: "Кандидат #{candidate.employee_cv.name} с анкетой №#{candidate.employee_cv.id} нанят",
          object_id: candidate.employee_cv.id,
          object_type: 'EmployeeCv',
          order_id: candidate.order_id,
          employee_cv_id: candidate.employee_cv_id
        }
      end
    end
  end
end
