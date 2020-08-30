module Cmd
  module NotifyMail
    module ProposalEmployee
      class Hire
        include Interactor

        delegate :proposal_employee, to: :context

        def call
          return unless proposal_employee.profile.notify_mails?

          ProposalEmployeeMailJob.perform_now(proposal_employees: [proposal_employee], method: 'proposal_employee_hired') 
        end
      end
    end
  end
end