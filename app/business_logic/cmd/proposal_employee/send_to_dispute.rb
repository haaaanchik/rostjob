# frozen_string_literal: true

module Cmd
  module ProposalEmployee
    class SendToDispute
      include Interactor

      delegate :candidate, to: :context

      def call
        context.fail! unless candidate.to_disputed!

        incident = ::Incident.new(incident_params)
        context.fail! unless incident.save
        Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def employee_cv
        @employee_cv ||= candidate.employee_cv
      end

      def user
        @user ||= candidate.order.user
      end

      def incident_params
        {
          title: :other,
          user_id: user.id,
          proposal_employee_id: candidate.id,
          waiting: 'customer',
          messages_attributes: {
            '0': {
              text: 'Пожалуйста, уточните статус соискателя!',
              sender_name: user.full_name,
              sender_id: user.id
            }
          }
        }
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
          object_type: 'EmployeeCv',
          employee_cv_id: employee_cv.id
        }
      end
    end
  end
end
