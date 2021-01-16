# frozen_string_literal: true

module Cmd
  module ProposalEmployee
    class ToPay
      include Interactor

      delegate :user,      to: :context
      delegate :candidate, to: :context

      def call
        context.fail! unless candidate.to_paid!

        calculate_deal_counter
        set_context
      end

      private

      def set_context
        context.order_profile = candidate.order.profile
      end

      def calculate_deal_counter
        candidate.order.profile.increment!(:deal_counter)
        candidate.profile.increment!(:deal_counter)
        candidate.order.production_site.increment!(:deal_counter)
      end
    end
  end
end
