module Cmd
  module NotifyMail
    module ProposalEmployee
      class Interview
        include Interactor

        delegate :proposal_employee, to: :context

        def call
          return unless proposal_employee.profile.notify_mails?

          ProposalEmployeeMailJob.perform_now(proposal_employees: [proposal_employee], method: 'informated_contractor_about_interview')
        end
      end
    end
  end
end