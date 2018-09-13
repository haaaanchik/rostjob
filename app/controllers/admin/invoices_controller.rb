class Admin::InvoicesController < Admin::ApplicationController
  def index
    invoices
  end

  def pay
    invoice.pay!
    redirect_to admin_invoices_path
  end

  private

  def invoice
    @invoice ||= Invoice.find(params[:id])
  end

  def invoices
    @invoices ||= Invoice.order(created_at: :desc)
  end
end
