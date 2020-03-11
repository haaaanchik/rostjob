module Cmd
  module Ticket
    module Incident
      class Hire
        include Interactor

        def call
          incident.to_closed!
          candidate.update(hiring_date: hiring_date)
          candidate.hire!
        end

        private

        def hiring_date
          context.hiring_date
        end

        def candidate
          incident.proposal_employee
        end

        def incident
          context.incident
        end
      end
    end
  end
end
