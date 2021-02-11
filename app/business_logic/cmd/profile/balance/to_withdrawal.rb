# frozen_string_literal: true

module Cmd
  module Profile
    module Balance
      class ToWithdrawal
        include Interactor

        delegate :profile,     to: :context
        delegate :invoice,     to: :context
        delegate :reason_text, to: :context

        def call
          profile.balance.withdraw(amount, reason_text, invoice.id)
        end

        private

        def amount
          context.amount || profile.balance.amount
        end
      end
    end
  end
end
