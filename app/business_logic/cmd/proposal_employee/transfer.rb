module Cmd
  module ProposalEmployee
    class Transfer
      include Interactor

      def call
        context.fail! unless context.candidate.to_transfer!
        result = context.candidate.update(dst_order_id: dst_order_id)
        context.fail! unless result
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
        SendTransferMailJob.perform_later(candidate: candidate)
      end

      private

      def candidate
        context.candidate
      end

      def dst_order_id
        context.dst_order_id
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
          action: "Создан запрос на перемещение анкеты ##{candidate.employee_cv.id} кандидата #{candidate.employee_cv.name} в заявку №#{candidate.dst_order_id}",
          object_id: candidate.employee_cv.id,
          object_type: 'EmployeeCv',
          order_id: candidate.order_id,
          employee_cv_id: candidate.employee_cv_id
        }
      end
    end
  end
end
