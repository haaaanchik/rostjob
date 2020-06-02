module Cmd
  module Invoice
    class Pay
      include Interactor

      delegate :invoice, to: :context

      def call
        invoice.pay!
        invoice.profile.balance.deposit(invoice.amount, 'Пополнение баланса')
        OrderPublicationJob.perform_later(invoice.id)
      end
    end
  end
end
