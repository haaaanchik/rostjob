module Cmd
  module Ticket
    module Message
      class Create
        include Interactor

        def call
          message = context.ticket.messages.build(message_params)
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

        def user
          context.user
        end
      end
    end
  end
end
