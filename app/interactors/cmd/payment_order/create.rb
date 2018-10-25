module Cmd
  module PaymentOrder
    class Create
      include Interactor

      def call
        profile = context.profile
        company = profile.company
        amount = context.amount
        payment_order_params = payment_order(company, amount)
        company.payment_orders.create(payment_order_params)
      end

      private

      def payment_order(company, amount)
        {
          number: nil,
          date: Date.today,
          type_of_payment: 'Электронно',
          amount: amount,
          payer: counterparty(Company.own.first),
          receiver: counterparty(company),
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
