module Cmd
  module ProposalEmployee
    class ApproveListActs
      include Interactor

      delegate :candidates, to: :context
      delegate :profile, to: :context

      def call
        acts = candidates.where(profile_id: profile.id)
        context.fail! if acts.blank?
        acts.each do |act|
          pay = Cmd::ProposalEmployee::Pay.call(candidate: act)
          context.fail! if pay.failure?
        end
      end
    end
  end
end
