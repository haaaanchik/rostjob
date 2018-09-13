module NewInvoice
  class Create
    include Interactor

    def call
      invoice_params = context.invoice_params
      profile = context.profile
      invoice_params[:seller] = seller
      invoice_params[:buyer] = buyer(profile)
      invoice_params[:goods] = goods
      invoice = profile.invoices.create(invoice_params)
      context.invoice = invoice if invoice.persisted?
      context.fail!(invoice: invoice) unless invoice.persisted?
    end

    private

    def seller
      {
        company_name: Company.first[:short_name]
      }
    end

    def buyer(profile)
      {
        company_name: profile.company_name
      }
    end

    def goods
      [
        { title: 'Услуги по размещению заявки на поиск персонала', unit: 'шт', quantity: 1, price: 8000 }
      ]
    end
  end
end
