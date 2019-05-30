module Cmd
  module ProposalEmployee
    class ToInterview
      include Interactor

      def call
        context.fail! unless candidate.update(interview_date: interview_date)
        context.fail! unless candidate.to_interview!
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def candidate
        context.candidate
      end

      def interview_date
        context.interview_date
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
          action: "Кандидату #{candidate.employee_cv.name} с анкетой №#{candidate.employee_cv.id} назначена дата собеседования #{candidate.interview_date.strftime('%d.%m.%Y')}",
          object_id: candidate.employee_cv.id,
          object_type: 'EmployeeCv',
          order_id: candidate.order_id,
          employee_cv_id: candidate.employee_cv_id
        }
      end
    end
  end
end
