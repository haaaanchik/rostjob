class Profile::InvoicesController < ApplicationController
  def index
    @invoice = Invoice.new(amount: params[:amount])
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
    if current_profile.filled?
      result = ::Cmd::Invoice::Create.call(amount: amount, profile: current_profile)
      if result.success?
        redirect_to profile_invoices_path(state: 'created')
      else
        @invoice = result.invoice
        invoices
        render 'index'
      end
    else
      redirect_to edit_profile_path
    end
  end

  def destroy
    invoice.destroy
    redirect_to profile_invoices_path
  end

  private

  def amount
    invoice_params[:amount]
  end

  def invoice_params
    params.require(:invoice).permit(:amount)
  end

  def invoice
    @invoice ||= invoices.find(params[:id])
  end

  def invoices
    @invoices ||= current_profile.invoices.customers.order(created_at: :desc)
  end
end
