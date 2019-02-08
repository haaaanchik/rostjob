module Cmd
  module ProposalEmployee
    class Create
      include Interactor

      def call
        @employee_pr = employee_cv.create_pr_empl proposal_id
        context.fail! unless @employee_pr.persisted?
        context.employee_pr = @employee_pr
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def employee_cv
        context.employee_cv
      end

      def proposal_id
        context.proposal_id
      end

      def current_user
        profile.user
      end

      def profile
        employee_cv.profile
      end

      def logger_params
        {
          receiver_ids: [current_user.id],
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: 'Анкета отправлена',
          object_id: @employee_pr.id,
          object_type: 'ProposalEmployee'
        }
      end
    end
  end
end
