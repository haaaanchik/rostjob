# frozen_string_literal: true

module Cmd
  module NotifyMail
    module ProposalEmployee
      class Pay
        include Interactor

        delegate :candidate, to: :context

        def call
          return unless candidate.profile.notify_mails?

          ProposalEmployeeMailJob.perform_now(proposal_employees: [candidate], method: 'informated_contractor_has_paid')
        end
      end
    end
  end
end
