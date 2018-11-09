module Cmd
  module PaymentOrder
    class Create
      include Interactor

      def call
        profile = context.profile
        receiver = profile.company
        amount = context.amount
        payment_order_params = payment_order(receiver, amount)
        Company.own_active.payment_orders.create(data: payment_order_params)
      end

      private

      def payment_order(receiver, amount)
        {
          number: nil,
          date: Date.current,
          type_of_payment: 'Электронно',
          amount: amount,
          payer: counterparty(Company.own_active),
          receiver: counterparty(receiver),
          kind_of_payment: '01',
          priority: 5,
          purpose_of_payment: 'Вознаграждение по договору. НДС нет.'
        }
      end

      def counterparty(company)
        account = company.accounts.first
        {
          name: company[:name],
          inn: company[:inn],
          kpp: company[:kpp],
          account: {
            account_number: account[:account_number],
            corr_account: account[:corr_account],
            bic: account[:bic],
            bank: account[:bank],
            bank_address: account[:bank_address]
          }
        }
      end
    end
  end
end
