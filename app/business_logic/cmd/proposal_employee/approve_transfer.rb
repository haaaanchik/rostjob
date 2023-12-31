module Cmd
  module ProposalEmployee
    class ApproveTransfer
      include Interactor

      def call
        context.fail! unless context.candidate.to_inbox
        result = context.candidate.update(order_id: dst_order_id)
        context.fail! unless result
        # Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def candidate
        context.candidate
      end

      def dst_order_id
        candidate.dst_order_id
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
          action: "Кандидат #{candidate.employee_cv.name} с анкетой №#{candidate.employee_cv.id} перемещён в заявку №#{candidate.dst_order_id}",
          object_id: candidate.employee_cv.id,
          object_type: 'EmployeeCv',
          order_id: candidate.order_id,
          employee_cv_id: candidate.employee_cv_id
        }
      end
    end
  end
end
