class ProfilesController < ApplicationController

  def show
    profile
  end

  def edit
    profile
  end

  def update
    @result = Cmd::Profile::Update.call(profile: current_profile, params: profile_params)
    @result.profile
    if @result.success?
      current_profile.update_attribute(:updated_by_self_at, DateTime.now)
      redirect_to edit_profile_path, notice: 'Анкета обновлена'
    else
      render json: { validate: true, data: errors_data(@result.profile) }, status: 422
    end
  end


  def set_free
    @status = if profile.phone.present?
                Cmd::FreeManager::Add.call(user: current_user, phone: profile.phone)
                true
              else
                false
              end
  end

  def unset_free
    Cmd::FreeManager::Remove.call(user_id: current_user.id)
  end

  private

  def company?
    params[:profile][:legal_form] == 'company'
  end

  def profile
    @profile ||= current_profile
  end

  def profile_params
    params.require(:profile)
          .permit(:photo, :contact_person, :phone, :company_name, :email, :profile_type, :legal_form,
                  company_attributes: [:id, :name, :short_name, :address, :mail_address, :phone,
                                       :fax, :email, :inn, :kpp, :ogrn, :director, :acts_on, :legal_form,
                                       accounts_attributes: %i[id account_number corr_account bic bank
                                                               bank_address inn kpp number_contract]])
  end
end
