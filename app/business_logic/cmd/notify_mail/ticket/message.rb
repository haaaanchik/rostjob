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
          if user.is_a?(Staffer)
            send_message(customer)
            send_message(contractor)
          else
            send_to = user == customer ? contractor : customer
            send_message(send_to)
          end
        end

        private

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
