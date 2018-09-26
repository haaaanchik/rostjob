module NewInvoice
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
    end

    private

    def seller
      company = Company.own.first
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
      {
        short_name: profile.company.short_name
      }
    end

    def goods(price)
      [
        { title: 'Услуги по размещению заявки на поиск персонала', unit: 'шт', quantity: 1, price: price }
      ]
    end
  end
end
