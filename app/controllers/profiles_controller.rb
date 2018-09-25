class ProfilesController < ApplicationController
  skip_before_action :create_profile, only: %i[new create]

  def show
    profile
  end

  def new
    @profile = Profile.new
    @profile.build_company.accounts.build
  end

  def edit
    profile
  end

  def create
    @profile = current_user.create_profile(profile_params)
    if @profile.errors.messages.any?
      render json: errors_data(@profile)
    else
      current_user.update_attribute(:profile_id, @profile.id)
      redirect_to root_path
    end
  end

  def update
    profile.assign_attributes(profile_params.except(:profile_type))
    result = profile.save
    if result
      redirect_to root_path
    else
      render profile.filled? ? 'edit' : 'show'
    end
  end

  private

  def profile
    @profile ||= current_profile
  end

  def profile_params
    params.require(:profile)
          .permit(:photo, :contact_person, :phone, :company_name, :email, :profile_type,
                  company_attributes: [:id, :name, :short_name, :address, :mail_address, :phone,
                                       :fax, :email, :inn, :kpp, :ogrn, :director, :acts_on,
                                       accounts_attributes: %i[id account_number corr_account bic
                                                               bank bank_address]])
  end
end
