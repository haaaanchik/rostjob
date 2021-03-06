class Profile::BalancesController < ApplicationController
  before_action :set_authorize

  def show
    balance
  end

  def deposit
    balance.deposit(balance_params[:value], 'Пополнение счёта')
    if balance.errors.any?
      render 'show'
    else
      redirect_to root_path
    end
  end

  def withdrawal_methods
    balance
  end

  def withdrawal
    result = Cmd::Profile::Balance::Withdrawal.call(profile: profile,
                                                    invoice: profile.invoices.new,
                                                    company: set_withdrawal_method.company,
                                                    reason_text: 'Перевод вознаграждения исполнителю')

    if result.success?
      @status = 'success'
    else
    end
  end

  def contractor_invoice
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

  def destroy
    bill_trans = profile.balance.bill_transactions.find(params[:id])
    if bill_trans.destroy
      flash[:notice] = 'Запись успешно удалена'
    else
      flash[:alert] = 'Ошибка, обратитесь к администрации'
    end

    redirect_to profile_balance_path
  end

  private

  def profile
    @profile ||= current_profile
  end

  def balance
    @balance ||= profile.balance
  end

  def balance_params
    params.permit(:value, :amount, :withdrawal_method_id)
    # params.require(:balance).permit(:value, :withdrawal_method_id)
  end

  def invoice
    Invoice.find(params[:id])
  end

  def set_authorize
    authorize [:profile, :balance]
  end

  def set_withdrawal_method
    @set_withdrawal_method ||= WithdrawalMethod.find(balance_params[:withdrawal_method_id])
  end
end
