# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_permitted_parameters, if: :devise_controller?
  # skip_before_action :authenticate_user!, except: :destroy
  skip_before_action :auth_user, except: :destroy
  skip_before_action :create_profile

  # GET /resource/sign_in
  def new
    @user = User.new
  end

  # POST /resource/sign_in
  def create
    usr = sessions_params
    flash['user_email'] = usr[:email]
    # return invalid_login_attempt if usr[:email].blank? || usr[:password].blank?
    return new_login_form if usr[:email].blank? || usr[:password].blank?

    user = User.find_by(email: usr[:email].downcase)
    # return invalid_login_attempt unless user

    if user&.valid_password?(usr[:password])
      if user.confirmed?
        sign_in :user, user
        redirect_to root_path
      else
        render js: "toastr.error('Необходимо подтвердить электронную почту!', 'Неудача!')",
               status: 401
      end
    else
      new_login_form
      # invalid_login_attempt
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def sessions_params
    params.require(:user).permit(:email, :password)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   params.permit(user: %i[email password])
  # end

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_in) do |user_params|
  #     user_params.permit(:password, :email)
  #   end
  # end

  def invalid_login_attempt
    set_flash_message(:alert, :invalid)
    render js: "toastr.error('Сочетания логина и пароля не найдено', 'Неудача!')",
           status: 401
  end

  def new_login_form
    @user = User.new(sessions_params)
    @user.errors[:base] << 'Введённое сочетание логина и пароля не найдено.'
    render 'users/sessions/new'
  end
end
