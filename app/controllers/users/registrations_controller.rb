# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!
  skip_before_action :auth_user

  # GET /resource/sign_up
  def new
    @user = User.new
  end

  def create
    user = User.new configure_sign_up_params

    if user.save
      user.send_confirmation_instructions
      sign_in :user, user
      redirect_to root_path
    else
      render js: "toastr.error('#{error_msg_handler user}', 'Не сохранено!');",
             status: 401
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

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  def configure_sign_up_params
    params.require(:user).permit(:password_confirmation, :password,
                                 :full_name, :email)
  end
end
