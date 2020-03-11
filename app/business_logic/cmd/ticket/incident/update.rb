module Cmd
  module Ticket
    module Incident
      class Update
        include Interactor

        def call
          context.fail! unless incident.update(incident_params)
        end

        private

        def incident_params
          context.incident_params
        end

        def incident
          context.incident
        end
      end
    end
  end
end
