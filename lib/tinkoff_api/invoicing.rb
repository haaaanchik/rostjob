class TinkoffApi::Invoicing
  class << self
    include TinkoffApi::Api

    def send_invoicing(invoice)
      @invoice = invoice

      invoicing('invoice/send', body_params)
    end

    private

    def body_params
      {
        invoiceNumber: (@invoice.last_invoice_number + 1).to_s,
        payer: {
          name: @invoice.buyer['name'],
          inn: @invoice.buyer['inn']
        },
        items: [
          {
            name: @invoice.goods.first['title'],
            price: @invoice.goods.first['price'].to_i,
            unit: @invoice.goods.first['unit'],
            vat: 'None',
            amount: @invoice.goods.first['quantity']
          }
        ],
        contacts: [
          { email: @invoice.profile.user.email }
        ]
      }
    end
  end
end