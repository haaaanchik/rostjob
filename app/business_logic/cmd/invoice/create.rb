module Cmd
  module Invoice
    class Create
      include Interactor

      def call
        invoice_params = context.invoice_params
        profile = context.profile
        invoice_params[:seller] = seller
        invoice_params[:buyer] = buyer(profile)
        invoice_params[:goods] = goods(invoice_params[:amount].to_i)
        invoice = profile.invoices.create(invoice_params)
        context.invoice = invoice if invoice.persisted?
        context.fail!(invoice: invoice) unless invoice.persisted?
        Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def seller
        company = Company.own_active
        account = company.accounts.first
        {
          short_name: company[:short_name],
          inn: company[:inn],
          kpp: company[:kpp],
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

      def buyer(profile)
        company = profile.company
        account = company.accounts.first
        {
          short_name: company.short_name,
          inn: company[:inn],
          kpp: company[:kpp],
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
          receiver_id: user.id,
          subject_id: user.id,
          subject_type: 'User',
          subject_role: user.profile ? user.profile.profile_type : nil,
          action: 'Выписан счет',
          object_id: context.invoice.id,
          object_type: 'Invoice'
        }
      end
    end
  end
end
