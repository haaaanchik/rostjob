# frozen_string_literal: true

module Cmd
  module NotifyMail
    module Ticket
      module Incident
        class Create
          include Interactor

          delegate :user,     to: :context
          delegate :incident, to: :context

          def call
            return unless send_to.profile.notify_mails?

            ProposalEmployeeMailJob.perform_now(user: send_to,
                                                proposal_employees: [incident.proposal_employee],
                                                method: 'informated_user_has_disputed')
          end

          private

          def send_to
            user.customer? ? pr_empl.user : pr_empl.order.user
          end

          def pr_empl
            incident.proposal_employee
          end
        end
      end
    end
  end
end
