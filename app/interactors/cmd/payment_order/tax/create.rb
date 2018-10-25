module Cmd
  module PaymentOrder
    module Tax
      class Create
        include Interactor

        def call
          amount = context.amount
          payer = context.payer
          kbk = context.kbk
          payment_order_params = payment_order(payer, kbk, amount)
          payer.payment_orders.create(data: payment_order_params)
        end

        private

        def payment_order(payer, kbk, amount)
          date = Date.today
          month = I18n.l(date, format: '%B').downcase
          year = date.year
          {
            date: Date.today,
            type_of_payment: 'Электронно',
            amount: amount,
            payer: counterparty(payer),
            receiver: tax_office(payer.tax_office),
            kind_of_payment: '01',
            priority: 5,
            purpose_of_payment: "Налог на доходы физических лиц за #{month} #{year} года"
          }.merge(
            tax_payment_fields(payer, kbk)
          )
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

        def tax_office(tax_office)
          {
            name: tax_office[:payment_name],
            inn: tax_office[:inn],
            kpp: tax_office[:kpp],
            account: {
              account_number: tax_office[:bank_account],
              corr_account: '',
              bic: tax_office[:bank_bic],
              bank: tax_office[:bank_name],
              bank_address: tax_office[:bank_name]
            }
          }
        end

        def tax_payment_fields(payer, kbk)
          date = Date.today
          month = date.strftime('%m')
          year = date.year
          {
            uin: 0,
            kbk: kbk,
            oktmo: payer.tax_office.oktmo,
            f101: '02',
            f106: 'ТП',
            f107: "МС.#{month}.#{year}",
            f108: 0,
            f109: 0
          }
        end
      end
    end
  end
end
