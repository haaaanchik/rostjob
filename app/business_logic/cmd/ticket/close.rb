module Cmd
  module Ticket
    class Close
      include Interactor

      delegate :ticket, to: :context

      def call
      context.fail! unless ticket.to_closed!
      hired_canidate
      end

      private

      def candidate
        ticket.proposal_employee
      end

      def hired_canidate
        return unless ticket.is_a? Incident

        candidate.hire!
      end
    end
  end
end
