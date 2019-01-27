# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!
  skip_before_action :auth_user

  # GET /resource/sign_up
  def new
    @user = User.new
  end

  def create
    result = ::Cmd::User::Registration::Create.call(user_params: user_params)
    @user = result.user
    @status = if result.success?
                'success'
              else
                error_msg_handler @user
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

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    redirect_to root_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    render js: "toastr.error('Необходимо подтвердить электронную почту!', 'Неудача!')",
           status: 401
  end

  def user_params
    params.require(:user).permit(:password_confirmation, :password,
                                 :full_name, :email)
  end
end
