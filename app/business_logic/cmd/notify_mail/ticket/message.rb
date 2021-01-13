# frozen_string_literal: true

module Cmd
  module NotifyMail
    module Ticket
      class Message
        include Interactor

        delegate :user,    to: :context
        delegate :ticket,  to: :context
        delegate :message, to: :context

        def call
          ticket.appeal? ? appeal_action : incident_action
        end

        private

        def appeal_action
          return unless user.is_a?(Staffer)

          notify_user
        end

        def incident_action
          if user.is_a?(Staffer)
            send_message(customer)
            send_message(contractor)
          else
            send_to = user == customer ? contractor : customer
            send_message(send_to)
          end
        end

        def notify_user
          ::TicketMailer.notify_user(message).deliver_now
        end

        def send_message(sended_user)
          TicketMailer.with(user: sended_user, ticket: ticket, message: message).new_message.deliver_now
        end

        def customer
          @customer = ticket.proposal_employee.order.user
        end

        def contractor
          @contractor = ticket.proposal_employee.user
        end
      end
    end
  end
end
