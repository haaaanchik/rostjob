class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]
  skip_before_action :create_profile

  def new
    errors
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      sign_in(user)
      redirect_to root_path
    else
      errors[:email] = 'неправильный логин'
      errors[:password] = 'или пароль'
      render json: errors
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def errors
    @errors ||= {}
  end
end
