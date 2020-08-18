module Cmd
  module NotifyMail
    module ProposalEmployee
      class Inbox
        include Interactor

        delegate :proposal_employee, to: :context

        def call
          return unless proposal_employee.profile.notify_mails?

          SendNotifyMailJob.perform_now(objects: [proposal_employee], method: 'emp_cv_sended')
        end
      end
    end
  end
end