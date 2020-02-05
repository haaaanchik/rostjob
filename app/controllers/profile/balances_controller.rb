class Profile::BalancesController < ApplicationController
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
    result = Cmd::Profile::Balance::Withdrawal.call(profile: profile, amount: balance.amount,
                                                    withdrawal_method_id: balance_params[:withdrawal_method_id])
    if result.success?
      @status = 'success'
    else
    end
  end

  def contractor_invoice
    invoice = Invoice.find(params[:id])
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
end
