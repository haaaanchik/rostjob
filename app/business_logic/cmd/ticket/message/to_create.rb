module Cmd
  module Ticket
    module Message
      class ToCreate
        include Interactor

        delegate :user,    to: :context
        delegate :ticket,  to: :context
        delegate :message, to: :context

        def call
          return unless context.message_params

          message = ticket.messages.build(message_params)
          context.message = message
          context.fail! unless context.message.save
        end

        private

        def message_params
          context.message_params.merge(sender_name: sender_name, sender_id: user.id)
        end

        def sender_name
          user.full_name
        end
      end
    end
  end
end
