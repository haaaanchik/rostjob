module Cmd
  module NotifyMail
    module ProposalEmployee
      class Revoke
        include Interactor

        delegate :user, to: :context
        delegate :proposal_employee, to: :context

        def call
          if user.is_a?(Staffer)
            [proposal_employee.user, proposal_employee.order.user].each do |user|
              send_direct_mail(user)
            end
          else
            send_direct_mail(send_to)
          end
        end

        private

        def send_to
          user.profile.customer? ? proposal_employee.user : proposal_employee.order.user
        end

        def send_direct_mail(sended_user)
          SendDirectMailJob.perform_now(user: sended_user, attrs: { proposal_employee: proposal_employee }, method: 'informated_about_revoke_candidate' )
        end
      end
    end
  end
end