class Admin::InvoicesController < Admin::ApplicationController
  def index
    paginated_invoices
  end

  def pay
    invoice.pay!
    balance.deposit(invoice.amount, 'Пополнение баланса')
    OrderPublicationJob.perform_later(invoice.id)
    redirect_to admin_invoices_path
  end

  private

  def balance
    invoice.profile.balance
  end

  def paginated_invoices
    @paginated_invoices ||= invoices.page(params[:page])
  end

  def invoice
    @invoice ||= Invoice.find(params[:id])
  end

  def invoices
    @invoices ||= Invoice.order(created_at: :desc)
  end
end
