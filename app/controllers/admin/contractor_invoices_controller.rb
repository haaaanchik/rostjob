class Admin::ContractorInvoicesController < Admin::ApplicationController
  def index
    @q = Invoice.ransack(params[:q])
    @paginated_invoices = @q.result(distinct: true).page(params[:page])
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

  def invoice
    @invoice ||= Invoice.find(params[:id])
  end

  def invoices
    @invoices ||= Invoice.contractors.order(created_at: :desc)
  end
end
