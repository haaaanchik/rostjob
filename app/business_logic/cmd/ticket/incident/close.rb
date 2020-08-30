module Cmd
  module Ticket
    module Incident
      class Close
        include Interactor

        delegate :incident, to: :context

        def call
          return unless incident

          context.fail! unless incident.to_closed!
        end
      end
    end
  end
end