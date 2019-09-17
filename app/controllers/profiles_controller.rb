class ProfilesController < ApplicationController
  skip_before_action :create_profile, only: %i[new create]
  before_action :redirect_if_already_created, only: %i[new create]

  def show
    profile
  end

  def new
    @profile = Profile.new
    company = @profile.build_company
    company.accounts.build
  end

  def edit
    profile
    unless profile.company
      company = @profile.build_company
      company.accounts.build
    end
  end

  def create
    result = Cmd::Profile::Create.call(user: current_user, params: profile_params)
    profile = result.profile
    if result.success?
      Cmd::Profile::Balance::Create.call(profile: profile)
      redirect_to root_path
    else
      render json: { validate: true, data: errors_data(profile) }
    end
  end

  def update
    result = Cmd::Profile::Update.call(profile: current_profile, params: profile_params)
    profile = result.profile
    if result.success?
      redirect_to root_path
    else
      render json: { validate: true, data: errors_data(profile) }, status: 422
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

  def redirect_if_already_created
    redirect_to edit_profile_path if current_profile
  end

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
                                       accounts_attributes: %i[id account_number corr_account bic
                                                               bank bank_address inn kpp]])
  end
end
