module Cmd
  module Ticket
    module Incident
      class ToUpdate
        include Interactor

        delegate :incident,        to: :context
        delegate :incident_params, to: :context

        def call
          context.fail! unless incident.update(incident_params)
        end
      end
    end
  end
end
