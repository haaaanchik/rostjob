module Cmd
  module Ticket
    module Appeal
      class Create
        include Interactor

        def call
          appeal = ::Appeal.new(appeal_params)
          context.appeal = appeal
          context.fail! unless context.appeal.save
        end

        private

        def appeal_params
          context.appeal_params.merge(
            user_id: user.id,
            messages_attributes: { '0' => messages_attributes.merge(sender_name: sender_name, sender_id: user.id) }
          )
        end

        def messages_attributes
          context.appeal_params['messages_attributes']['0']
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
