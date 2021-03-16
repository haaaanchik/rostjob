class Admin::InvoicesController < Admin::ApplicationController
  def index
    paginated_invoices
  end

  def pay
    result = Cmd::Admin::Invoice::Pay.call(invoice: invoice,
                                           amount: invoice.amount,
                                           profile: invoice.profile,
                                           reasons_text: 'Пополнение баланса')

    if result.success?
      flash[:notice] = 'Cчёт оплачен'
    else
      flash[:alert] = 'Ошибка'
    end

    redirect_to admin_invoices_path
  end

  def destroy
    if invoice.destroy
      flash[:notice] = 'Счёт успешно удалён'
    else
      flash[:alert] = 'Ошибка при удаление счёта'
    end

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
    @invoices ||= Invoice.customers.order(created_at: :desc)
  end
end
