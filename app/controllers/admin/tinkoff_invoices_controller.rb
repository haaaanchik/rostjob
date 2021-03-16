module Admin
  class TinkoffInvoicesController < ::Admin::ApplicationController
    def index
      @invoices = TinkoffApi::BankStatement.invoices_between_date(params[:date_from], params[:date_to])
    end
  end
end
