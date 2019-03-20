module Cmd
  module Invoice
    class Create
      include Interactor

      def call
        invoice_params = {}
        seller, buyer = if profile.customer?
                          [Company.own_active, profile.company]
                        elsif profile.contractor?
                          [company, Company.own_active]
                        end
        invoice_params[:amount] = amount
        invoice_params[:seller] = counterparty(seller)
        invoice_params[:buyer] = counterparty(buyer)
        invoice_params[:goods] = goods(amount)
        invoice = profile.invoices.create(invoice_params)
        context.invoice = invoice if invoice.persisted?
        context.fail!(invoice: invoice) unless invoice.persisted?
        Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def company
        context.company
      end

      def profile
        context.profile
      end

      def amount
        context.amount
      end

      def counterparty(company)
        account = company.active_account
        {
          name: company.name,
          short_name: company.short_name,
          inn: company.private_person? ? account[:inn] : company[:inn],
          kpp: company.private_person? ? account[:kpp] : company[:kpp],
          address: company[:address],
          account: {
            account_number: account[:account_number],
            corr_account: account[:corr_account],
            bic: account[:bic],
            bank: account[:bank],
            bank_address: account[:bank_address]
          }
        }
      end

      def goods(price)
        [
          { title: 'Услуги по размещению заявки на поиск персонала', unit: 'шт', quantity: 1, price: price }
        ]
      end

      def logger_params
        user = context.profile.user
        {
          login: user.email,
          receiver_ids: [user.id],
          subject_id: user.id,
          subject_type: 'User',
          subject_role: user.profile ? user.profile.profile_type : nil,
          action: "Выписан счет №#{context.invoice.invoice_number} на сумму #{context.invoice.amount}",
          object_id: context.invoice.id,
          object_type: 'Invoice'
        }
      end
    end
  end
end
