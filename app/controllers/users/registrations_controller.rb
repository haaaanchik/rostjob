# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :auth_user
  before_action :set_user_new, only: %i[new_contractor new_customer]
  before_action :configure_update_params, only: :update

  # GET /resource/sign_up
  def new
    @user = User.new
  end

  def new_contractor; end

  def new_customer; end

  def contractor_info
    @message = 'Для регистрации или найма персонала обратитесь по адресу manager@rostjob.com или по номеру 8 800 700 67 86'
    render 'users/inform_page'
  end

  def create
    rnd = params["random"]
    captcha_resp = params["captcha"]["captcha"]
    if Captcha.check(captcha_resp, rnd)
      result = if params[:role] == 'customer'
                 ::Cmd::User::Registration::CreateCustomer.call(user_params: user_params,
                                                                profile_params: { profile_type: 'customer', legal_form: 'company' })
               else
                 ::Cmd::User::Registration::CreateContractor.call(user_params: user_params,
                                                                  profile_params: { profile_type: 'contractor' })
               end

      if result.success?
        @message = 'Cпасибо за регистрацию. На указанный вами адрес электронной почты направлена ссылка
          для активации учетной записи. Если письмо долго не приходит, проверьте папку "СПАМ" вашей почты.'
        render 'users/inform_page'
      else
        @reg_error = true
        @wrong_captcha = false
        render "users/registrations/new_#{params[:role]}"
      end
    else
      @reg_error = false
      @wrong_captcha = true
      render "users/registrations/new_#{params[:role]}"
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: {  validate: true,
                      data: errors_data(resource) },
             status: 422
    end
  end

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
                                          company_attributes: %i[id phone description]]])
  end

  # The path used after sign up.
  def after_sign_up_path_for(_resource)
    redirect_to root_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(_resource)
    render js: "toastr.error('Необходимо подтвердить электронную почту!', 'Неудача!')",
           status: 401
  end

  def after_update_path_for(resource)
    sign_in_after_change_password? ? signed_in_root_path(resource) : new_session_path(resource_name)
  end

  def user_params
    params.require(:user).permit(:email, :full_name)
  end

  def update_resource(resource, params)
    if resource.password_changed_at.nil?
      resource.update_without_curr_password(params)
    else
      resource.update_with_be_password(params)
    end
  end

  def set_user_new
    @user = User.new
  end
end
