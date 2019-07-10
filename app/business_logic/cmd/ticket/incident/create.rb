module Cmd
  module Ticket
    module Incident
      class Create
        include Interactor

        def call
          incident = ::Incident.new(incident_params)
          context.incident = incident
          context.fail! unless context.incident.save
        end

        private

        def incident_params
          context.incident_params.merge(
            user_id: user.id,
            messages_attributes: { '0' => messages_attributes.merge(sender_name: sender_name, sender_id: user.id) }
          )
        end

        def messages_attributes
          context.incident_params['messages_attributes']['0']
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
