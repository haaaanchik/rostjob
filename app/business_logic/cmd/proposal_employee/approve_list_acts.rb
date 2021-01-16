module Cmd
  module ProposalEmployee
    class ApproveListActs
      include Interactor

      delegate :candidates, to: :context
      delegate :profile_id, to: :context

      def call
        acts = candidates.where(profile_id: profile_id)
        context.fail! if acts.blank?
        acts.each do |act|
          pay = Cmd::ProposalEmployee::Pay.call(candidate: act, log: true)
          context.fail! if pay.failure?
        end
      end
    end
  end
end
