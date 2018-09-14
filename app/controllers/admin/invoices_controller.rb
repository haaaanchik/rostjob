class Admin::InvoicesController < Admin::ApplicationController
  def index
    invoices
  end

  def pay
    invoice.pay!
    balance.deposit(invoice.amount, 'Пополнение баланса')
    redirect_to admin_invoices_path
  end

  private

  def balance
    invoice.profile.balance
  end

  def invoice
    @invoice ||= Invoice.find(params[:id])
  end

  def invoices
    @invoices ||= Invoice.order(created_at: :desc)
  end
end
