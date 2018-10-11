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
    company.build_tax_office
  end

  def edit
    profile
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if company?
      @profile.save(context: :company)
    else
      @profile.save
    end
    if @profile.errors.messages.any?
      render json: errors_data(@profile)
    else
      current_user.update_attribute(:profile_id, @profile.id)
      @profile.create_balance
      redirect_to root_path
    end
  end

  def update
    profile.assign_attributes(profile_params.except(:profile_type, :legal_form))
    if company?
      profile.save(context: :company)
    else
      profile.save
    end

    if profile.errors.messages.any?
      render json: errors_data(@profile)
    else
      redirect_to root_path
    end
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
                                       :fax, :email, :inn, :kpp, :ogrn, :director, :acts_on,
                                       accounts_attributes: %i[id account_number corr_account bic
                                                               bank bank_address inn kpp],
                                       tax_office_attributes: %i[code name name_short payment_name
                                                                 oktmo inn kpp bank_name bank_bic
                                                                 bank_account]])
  end
end
