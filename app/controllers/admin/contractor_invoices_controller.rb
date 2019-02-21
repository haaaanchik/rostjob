class Admin::ContractorInvoicesController < Admin::ApplicationController
  def index
    paginated_invoices
  end

  def show
    invoice
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ContractorInvoicePdf.new(invoice, view_context)
        send_data pdf.render, filename: "Счёт #{invoice.invoice_number} от #{l(invoice.created_at, format: :short)}.pdf",
                              type: 'application/pdf',
                              disposition: 'inline'
      end
    end
  end

  private

  def paginated_invoices
    @paginated_invoices ||= invoices.page(params[:page])
  end

  def invoice
    @invoice ||= Invoice.find(params[:id])
  end

  def invoices
    @invoices ||= Invoice.contractors.order(created_at: :desc)
  end
end
