class TinkoffApi::BankStatement
  class << self
    include TinkoffApi::Api

    def fetch_invoices(invoice)
      @invoice = invoice

      statement_invoices('bank-statement?accountNumber=' + account_number + '&from=' + date + '&till=' + date )
    end

    def invoices_between_date(from, till)
      from ||= current_day
      till ||= current_day
      response = statement_invoices("bank-statement?accountNumber=#{account_number}&from=#{from}&till=#{till}")
      response['operation']
    end

    private

    def account_number
      Rails.application.credentials[:tinkoff][:account_number]
    end

    def date
      @invoice.created_at.strftime('%Y-%m-%d')
    end

    def current_day
      DateTime.now.strftime('%Y-%m-%d')
    end
  end
end
