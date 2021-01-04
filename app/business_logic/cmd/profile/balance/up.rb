# frozen_string_literal: true

module Cmd
  module Profile
    module Balance
      class Up
        include Interactor

        delegate :amount,  to: :context
        delegate :profile, to: :context

        def call
          context.fail! unless profile || amount

          profile.balance.deposit(amount, reasons_text)
        end

        private

        def reasons_text
          context.reasons_text || 'Пополнение баланса без указаний причин'
        end
      end
    end
  end
end
