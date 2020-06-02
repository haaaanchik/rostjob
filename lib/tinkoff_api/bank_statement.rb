class TinkoffApi::BankStatement
  class << self
    include TinkoffApi::Api

    def fetch_invoices(invoice)
      @invoice = invoice

      statement_invoices('bank-statement?accountNumber=' + account_number + '&from=' + date + '&till=' + date )
    end

    private

    def account_number
      app_env = Rails.env.to_sym
      Rails.application.credentials[app_env][:tinkoff][:account_number]
    end

    def date
      @invoice.created_at.strftime('%Y-%m-%d')
    end
  end
end
