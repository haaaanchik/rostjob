class CheckInvoiceTinkoffJob < ApplicationJob
  queue_as :processing

  def perform(invoice)
    @invoice = invoice
    @response = TinkoffApi::BankStatement.fetch_invoices(@invoice)
    @invoice.update(error_message: @response[:error]) unless @response['accountNumber'].present?
    return update_checking_pay if @response['operation'].blank?
    fetch_invoice
    update_checking_pay
  end

  private

  def fetch_invoice
    inv = @response['operation'].select { |item| item['amount'] == @invoice.amount.to_i }
    ::Cmd::Invoice::Pay.call(invoice: @invoice) if inv.present?
  end

  def update_checking_pay
    @invoice.update(checking_pay: false)
  end
end
