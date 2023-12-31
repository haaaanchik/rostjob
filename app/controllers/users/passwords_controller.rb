# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  # skip_before_action :authenticate_user!
  skip_before_action :auth_user
  # GET /resource/password/new
  def new
    @user = User.new
  end

  # POST /resource/password
  def create
    rnd = params["random"]
    captcha_resp = params["captcha"]["captcha"]
    if Captcha.check(captcha_resp, rnd)
      result = Cmd::User::ResetPassword.call(user_email: params[:user][:email])

      if result.success?
        flash[:notice] = result.message
        after_sending_reset_password_instructions_path_for(result.user)
      else
        flash[:alert] = result.message
        render :new
      end
    else
      flash[:alert] = "Неверный код с картинки"
      render :new
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:user) do |user_params|
      user_params.permit(:email)
    end
  end

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(user)
    redirect_to root_path
  end
end
