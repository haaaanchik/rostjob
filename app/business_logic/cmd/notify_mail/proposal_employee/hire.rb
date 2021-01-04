module Cmd
  module NotifyMail
    module ProposalEmployee
      class Hire
        include Interactor

        def call
          return unless proposal_employee.profile.notify_mails?

          ProposalEmployeeMailJob.perform_now(proposal_employees: [proposal_employee], method: 'proposal_employee_hired') 
        end

        private

        def proposal_employee
          context.proposal_employee || context.candidate
        end
      end
    end
  end
end