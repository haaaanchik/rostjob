module Cmd
  module Invoice
    class ToPay
      include Interactor

      delegate :invoice, to: :context

      def call
        context.fail! unless invoice.pay!
      end
    end
  end
end
