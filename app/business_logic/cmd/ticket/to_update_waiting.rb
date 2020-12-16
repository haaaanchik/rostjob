# frozen_string_literal: true

module Cmd
  module Ticket
    class ToUpdateWaiting
      include Interactor

      delegate :user, to: :context

      def call
        return if user.is_a?(Staffer) || ticket.waiting == user.profile.profile_type

        context.fail! unless ticket.update_waiting!
      end

      private

      def ticket
        context.ticket || context.incident
      end
    end
  end
end
