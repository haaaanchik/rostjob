class Profile::InvoicesController < ApplicationController
  def index
    @invoice = Invoice.new
    invoices
  end

  def show
    invoice
  end

  def create
    result = ::NewInvoice::Create.call(invoice_params: invoice_params, profile: current_profile)
    if result.success?
      redirect_to profile_invoices_path
    else
      @invoice = result.invoice
      invoices
      render 'index'
    end
  end

  def destroy
    invoice.destroy
    redirect_to profile_invoices_path
  end

  private

  def invoice_params
    params.require(:invoice).permit(:amount)
  end

  def invoice
    @invoice ||= invoices.find(params[:id])
  end

  def invoices
    @invoices ||= current_profile.invoices.order(created_at: :desc)
  end
end
