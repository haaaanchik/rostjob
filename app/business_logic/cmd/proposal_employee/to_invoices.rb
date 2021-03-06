# frozen_string_literal: true

module Cmd
  module ProposalEmployee
    class ToInvoices
      include Interactor

      delegate :profile, to: :context
      delegate :invoice, to: :context

      def call
        context.fail if canidates.count.zero?

        canidates.update_all(invoice_id: invoice.id)
      end

      private

      def canidates
        @canidates ||= ::ProposalEmployee.approved_by_admin.where(invoice_id: nil,
                                                                  profile_id: profile.id)
      end
    end
  end
end
