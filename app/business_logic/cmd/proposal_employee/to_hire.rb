# frozen_string_literal: true

module Cmd
  module ProposalEmployee
    class ToHire
      include Interactor

      delegate :candidate, to: :context
      delegate :order,     to: :context
      delegate :log,       to: :context

      def call

        context.fail! if hiring_date.blank? && order.number_free_places > 1

        candidate.update(hiring_date: hiring_date,
                         warranty_date: Holiday.warranty_date(hiring_date, order.warranty_period))
        candidate.hire!
      end

      private

      def order
        candidate.order
      end

      def hiring_date
        Date.parse(context.hiring_date)
      end
    end
  end
end
