module Cmd
  module ProposalEmployee
    class Hire
      include Interactor

      def call
        if hiring_date.present?
          candidate.update(hiring_date: hiring_date, warranty_date: Holiday.warranty_date(hiring_date))
          candidate.hire!
          # order.complete! if order.reload.candidates.hired.count == order.number_of_employees
        else
          context.fail!
        end

        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def order
        candidate.order
      end

      def hiring_date
        context.hiring_date
      end

      def candidate
        context.candidate
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
