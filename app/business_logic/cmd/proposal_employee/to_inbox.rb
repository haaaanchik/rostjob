module Cmd
  module ProposalEmployee
    class ToInbox
      include Interactor

      def call
        candidate.update(interview_date: interview_date)
        context.fail! unless candidate.to_inbox!
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def candidate
        context.candidate
      end

      def interview_date
        candidate.interview_date
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
          action: "Кандидат #{candidate.employee_cv.name} с анкетой №#{candidate.employee_cv.id} перемещён в очередь с датой прибытия #{interview_date.strftime('%d.%m.%Y')}",
          object_id: candidate.employee_cv.id,
          object_type: 'EmployeeCv',
          order_id: candidate.order_id,
          employee_cv_id: candidate.employee_cv_id
        }
      end
    end
  end
end
