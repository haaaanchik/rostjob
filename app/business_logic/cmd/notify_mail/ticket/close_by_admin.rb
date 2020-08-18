module Cmd
  module NotifyMail
    module Ticket
      class CloseByAdmin
        include Interactor

        delegate :ticket, to: :context

        def call
          ticket.proposal_employee.present? ? close_incident : close_ticket
        end

        private

        def close_incident
          ticket.members.each do |role, user|
            send_mail(user: user, ticket: false)
          end
        end

        def close_ticket
          send_mail(user: ticket.user, ticket: true)
        end

        def message
          "Инцидент №#{ticket.id}, был рассмотрен и закрыт администратором"
        end

        def send_mail(arg)
          return unless arg[:user].profile.notify_mails?

          SendDirectMailJob.perform_now(user: arg[:user], message: message, method: 'mail_about_close_incident',
                                          attrs: { incident: ticket, ticket: arg[:ticket] })
        end
      end
    end
  end
end