# frozen_string_literal: true

module Cmd
  module NotifyMail
    module Ticket
      module Incident
        class FailedInterview
          include Interactor

          delegate :proposal_employee, to: :context
          delegate :message, to: :context

          def call
            SendDirectMailJob.perform_now(attrs: { proposal_employee: proposal_employee },
                                          method: 'informated_about_failed_interview',
                                          user: proposal_employee.profile.user,
                                          message: message.text)
          end
        end
      end
    end
  end
end
