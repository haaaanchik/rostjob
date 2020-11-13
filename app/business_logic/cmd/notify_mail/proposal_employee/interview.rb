module Cmd
  module NotifyMail
    module ProposalEmployee
      class Interview
        include Interactor

        def call
          return unless proposal_employee.profile.notify_mails?

          ProposalEmployeeMailJob.perform_now(proposal_employees: [proposal_employee], method: 'informated_contractor_about_interview')
        end

        private

        def proposal_employee
          context.proposal_employee || context.candidate
        end
      end
    end
  end
end