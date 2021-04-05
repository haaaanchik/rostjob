# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # skip_before_action :authenticate_user!
  skip_before_action :auth_user

  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    user = User.find_by_confirmation_token(params[:confirmation_token])

    if user
      user.confirm
      sign_in(user)
      redirect_to edit_user_registration_path, notice: 'Электронная почта успешно подтверждена!'
    else
      redirect_to root_path, alert: 'Неверный токен. Попробуйте ещё раз.'
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
