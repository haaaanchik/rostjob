class TinkoffApi::BankStatement
  class << self
    include TinkoffApi::Api

    def fetch_invoices(invoice)
      @invoice = invoice

      statement_invoices('bank-statement?accountNumber=' + account_number + '&from=' + date + '&till=' + date )
    end

    def invoices_between_date(from, till)
      from = date_from(from)
      till = date_till(till)
      response = statement_invoices("bank-statement?accountNumber=#{account_number}#{from}#{till}")
      response['operation']
    end

    private

    def account_number
      Rails.application.credentials[:tinkoff][:account_number]
    end

    def date_from(from)
      from = last_seven_days if from.blank?

      "&from=#{from}"
    end

    def date_till(till)
      return if till.blank?

      "&till=#{till}"
    end

    def date
      @invoice.created_at.strftime('%Y-%m-%d')
    end

    def last_seven_days
      @last_seven_days = (DateTime.now - 7.days).strftime('%Y-%m-%d')
    end
  end
end
