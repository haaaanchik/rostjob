class Profile::InvoicesController < ApplicationController
  def index
    @invoice = Invoice.new(amount: params[:amount])
    @invoices = invoices.decorate
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
      @invoice = current_profile.invoices.new
      @result = ::Cmd::Invoice::Create.call(amount: amount,
                                            invoice: @invoice,
                                            profile: current_profile)
      if @result.success?
        redirect_to profile_invoices_path(state: 'created')
      else
        @invoices = invoices.decorate
        render :index
      end
    else
      redirect_to edit_profile_path
    end
  end

  def check_invoice_tinkoff
    invoice.update(checking_pay: true)
    CheckInvoiceTinkoffJob.perform_later(invoice)
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
    current_profile.invoices.customers.order(created_at: :desc)
  end
end
