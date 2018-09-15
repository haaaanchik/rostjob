class Profile::InvoicesController < ApplicationController
  def index
    @invoice = Invoice.new
    invoices
  end

  def show
    invoice
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InvoicePdf.new(invoice, view_context)
        send_data pdf.render, filename: "Счёт #{invoice.invoice_number} от #{l(invoice.created_at, format: :short)}.pdf",
                              type: 'application/pdf',
                              disposition: 'inline'
      end
    end
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
