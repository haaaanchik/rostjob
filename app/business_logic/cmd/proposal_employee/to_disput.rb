# frozen_string_literal: true

module Cmd
  module ProposalEmployee
    class ToDisput
      include Interactor

      delegate :user,        to: :context
      delegate :employee_cv, to: :context

      def call
        context.fail! unless proposal_employee.may_to_disputed?

        proposal_employee.to_disputed!
        Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def proposal_employee
        context.proposal_employee || context.candidate
      end

      def logger_params
        {
          login: user.email,
          receiver_ids: [user.id],
          subject_id: user.id,
          subject_type: 'User',
          subject_role: user.profile.profile_type,
          action: "По анкете №#{employee_cv.id} #{employee_cv.name} открыт спор",
          object_id: employee_cv.id,
          object_type: 'ProposalEmployee',
          employee_cv_id: employee_cv.id
        }
      end
    end
  end
end
