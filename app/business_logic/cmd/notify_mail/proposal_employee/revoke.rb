module Cmd
  module NotifyMail
    module ProposalEmployee
      class Revoke
        include Interactor

        delegate :user, to: :context
        delegate :proposal_employee, to: :context

        def call
          send_direct_mail(send_to)
        end

        private

        def admin?
          user.is_a?(Staffer)
        end

        def send_to
          admin? ? proposal_employee.user : proposal_employee.order.user
        end

        def send_direct_mail(sended_user)
          return unless sended_user.notify_mails?

          SendDirectMailJob.perform_now(user: sended_user,
                                        method: 'informated_about_revoke',
                                        attrs: { proposal_employee: proposal_employee, by_admin: admin? })
        end
      end
    end
  end
end