module Cmd
  module ProposalEmployee
    class ApproveListActs
      include Interactor

      def call
        acts = candidates.approved.find(selected_candidates_ids)
        context.fail! if acts.empty?
        acts.each do |act|
          pay = Cmd::ProposalEmployee::Pay.call(candidate: act)
          context.fail! if pay.failure?
        end
      end

      private

      def candidates
        context.candidates
      end

      def selected_candidates_ids
        context.selected_candidates_ids
      end
    end
  end
end
