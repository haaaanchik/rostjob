module Cmd
  module NotifyMail
    module Ticket
      module Incident
        class Close
          include Interactor

          delegate :message, to: :context

          def call
            return unless send_to_user.profile.notify_mails?

            SendDirectMailJob.perform_now(user: send_to_user, message: message.text, method: 'mail_about_close_incident',
                                          attrs: { incident: incident })
          end

          private

          def send_to_user
            if message.sender_id == incident.user_id
              @user = incident.proposal_employee.user
            else
              @user = incident.user
            end
          end

          def incident
            @incident ||= message.ticket
          end
        end
      end
    end
  end
end