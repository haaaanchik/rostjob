class Profile::WithdrawalMethodsController < ApplicationController

  def edit
    withdrawal_method
  end

  def update
    # OFF VALIDATE FOR FIELDS
    # if withdrawal_method.update(withdrawal_method_params)
    #   @status = 'success'
    # else
    #   render json: {  validate: true,
    #                   data: errors_data(withdrawal_method) },
    #                   status: 422
    # end

    withdrawal_method.assign_attributes(withdrawal_method_params)
    withdrawal_method.save(validate: false)
    @status = 'success'
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

  def withdrawal_method_params
    p = params.permit(withdrawal_method_company_account: {}, withdrawal_method_ip_account: {}, withdrawal_method_private_person_account: {})
    if p.key? :withdrawal_method_company_account
      p[:withdrawal_method_company_account]
    elsif p.key? :withdrawal_method_ip_account
      p[:withdrawal_method_ip_account]
    elsif p.key? :withdrawal_method_private_person_account
      p[:withdrawal_method_private_person_account]
    end
  end
end
