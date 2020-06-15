# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # skip_before_action :authenticate_user!
  skip_before_action :auth_user
  before_action :configure_update_params, only: :update

  # GET /resource/sign_up
  def new
    @user = User.new
  end

  def contractor_info
    @message = 'Для регистрации или найма персонала обратитесь по адресу manager@rostjob.com или по номеру +7 960 079 06 41'
    render 'users/inform_page'
  end

  def create
    result = if params.key? :customer
      ::Cmd::User::Registration::CreateCustomer.call(user_params: user_params)
    elsif params.key? :contractor
      ::Cmd::User::Registration::CreateContractor.call(user_params: user_params)
    end

    @user = result.user
    @status = if result.success?
                @message = 'Cпасибо за регистрацию. На указанный вами адрес электронной почты направлена ссылка
                  для активации учетной записи. Если письмо долго не приходит, проверьте папку "СПАМ" вашей почты.'
                render 'users/inform_page'
              else
                render 'users/registrations/new_contractor' if params.key?(:contractor)
                render 'users/registrations/new_customer' if params.key?(:customer)
                # render json: { validate: true, data: errors_data(result.user) }
              end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def configure_update_params
    devise_parameter_sanitizer
        .permit(:account_update,
                keys: [:full_name,
                       profile_attributes: [:id, :photo,
                                            company_attributes: [:id, :description]]])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    redirect_to root_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    render js: "toastr.error('Необходимо подтвердить электронную почту!', 'Неудача!')",
           status: 401
  end

  def after_update_path_for(resource)
    sign_in_after_change_password? ? signed_in_root_path(resource) : new_session_path(resource_name)
  end

  def user_params
    params.require(:user).permit(:email)
  end

  def update_resource(resource, params)
    if resource.password_changed_at.nil?
      resource.update_without_curr_password(params)
    else
      resource.skip_validation_password = params[:password].blank?
      resource.update_with_password(params)
    end
  end
end
