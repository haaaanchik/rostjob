module Cmd
  module Ticket
    class Close
      include Interactor

      def call
        if ticket.is_a? Appeal
          ticket.to_closed!
        elsif ticket.is_a? Incident
          ticket.to_closed!
          candidate.hire!
        end
      end

      private

      def candidate
        ticket.proposal_employee
      end

      def ticket
        context.ticket
      end
    end
  end
end
