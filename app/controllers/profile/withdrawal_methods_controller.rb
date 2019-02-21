class Profile::WithdrawalMethodsController < ApplicationController
  def edit
    withdrawal_method
  end

  def update
    if withdrawal_method.update(withdrawal_method_params)
      @status = 'success'
    else
      @text = error_msg_handler withdrawal_method
    end
  end

  private

  def withdrawal_method
    @withdrawal_method ||= withdrawal_methods.find(params[:id])
  end

  def withdrawal_methods
    @withdrawal_methods ||= profile.withdrawal_methods
  end

  def profile
    @profile ||= current_profile
  end

  def balance
    @balance ||= profile.balance
  end

  def balance_params
    params.require(:balance).permit(:value, :withdrawal_method_id)
  end

  def withdrawal_method_params
    p = params.permit(withdrawal_method_company_account: {}, withdrawal_method_ip_account: {}, withdrawal_method_private_person_account: {})
    if p.key? :withdrawal_method_company_account
      p[:withdrawal_method_company_account]
    elsif p.key? :withdrawal_method_ip_account
      p[:withdrawal_method_ip_account]
    elsif p.key? :withdrawal_method_private_person_account
      p[:withdrawal_method_private_person_account]
    end
    # params.require(:withdrawal_method_company_account).permit(company_attributes: [:id, :name, :short_name, :address, :mail_address, :phone,
    #                                            :fax, :email, :inn, :kpp, :ogrn, :director, :acts_on,
    #                                            accounts_attributes: %i[id account_number corr_account bic
    #                                            bank bank_address inn kpp]])
  end

  # def withdrawal_method_params
  #   params.require(:withdrawal_method)
  #         .permit(:title, company_attributes: [:id, :name, :short_name, :address, :mail_address, :phone,
  #                                              :fax, :email, :inn, :kpp, :ogrn, :director, :acts_on,
  #                                              accounts_attributes: %i[id account_number corr_account bic
  #                                                              bank bank_address inn kpp]])
  # end
end
