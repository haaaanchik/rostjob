# frozen_string_literal: true

module Cmd
  module NotifyMail
    module Ticket
      module Incident
        class SendHistoryAdmin
          include Interactor

          delegate :user,    to: :context
          delegate :ticket,  to: :context
          delegate :message, to: :context

          def call
            return if user.is_a?(Staffer)

            SendDirectMailJob.perform_now(method: 'incident_histofy_for_admin',
                                          attrs: { messages: messages, ticket: ticket })
          end

          private

          def messages
            ticket.messages.order(created_at: :desc).limit(10)
          end
        end
      end
    end
  end
end
