# frozen_string_literal: true

module Cmd
  module NotifyMail
    module ProposalEmployee
      class Interview
        include Interactor

        delegate :user,              to: :context
        delegate :proposal_employee, to: :context

        def call
          if user.is_a?(Staffer)
            send(customer)
            send(contractor)
          else
            user.customer? ? send(contractor) : send(customer)
          end
        end

        private

        def customer
          proposal_employee.order.user
        end

        def contractor
          proposal_employee.user
        end

        def send(current_user)
          return unless current_user.notify_mails?

          ProposalEmployeeMailJob.perform_now(user: current_user,
                                              proposal_employees: [proposal_employee],
                                              method: 'informate_about_interview')
        end
      end
    end
  end
end
