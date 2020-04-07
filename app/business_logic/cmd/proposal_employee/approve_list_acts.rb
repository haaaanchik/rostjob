module Cmd
  module ProposalEmployee
    class ApproveListActs
      include Interactor

      def call
        acts = candidates.approved.where('proposal_employees.profile_id': profile_id)
        context.fail! if acts.empty?
        acts.each do |act|
          pay = Cmd::ProposalEmployee::Pay.call(candidate: act)
          context.fail! if pay.failure?
        end
      end

      private

      def profile_id
        context.profile_id
      end

      def candidates
        context.candidates
      end
    end
  end
end
