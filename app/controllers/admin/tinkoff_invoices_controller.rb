module Admin
  class TinkoffInvoicesController < ::Admin::ApplicationController
    before_action :set_authorize

    def index
      @invoices = TinkoffApi::BankStatement.invoices_between_date(params[:date_from], params[:date_to])
    end

    private

    def set_authorize
      authorize([:admin, :tinkoff_invoice], :show?)
    end
  end
end
