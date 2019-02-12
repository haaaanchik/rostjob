module Cmd
  module Order
    class AddToFavorites
      include Interactor

      def call
        context.fail! unless order.order_profiles.create profile: profile
        # FIXME: refactor this ASAP
        # proposal = order.proposals.create accepted: true, profile_id: profile.id
        proposal = Proposal.find_or_create_by(order_id: order.id, accepted: true, profile_id: profile.id)
        context.proposal = proposal
        context.fail! unless proposal.persisted?
        message = proposal.messages.create text: 'СООБЩЕНИЕ ДЛЯ ЗАКАЗЧИКА', sender_id: profile.id
        context.fail! unless message.persisted?
      end

      private

      def order
        context.order
      end

      def profile
        context.profile
      end
    end
  end
end
