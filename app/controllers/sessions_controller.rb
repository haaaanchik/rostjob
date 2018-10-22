class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]
  skip_before_action :create_profile
  skip_before_action :verify_authenticity_token, if: -> { auth }

  def new
    errors
  end

  def create
    if auth
      user = User.find_or_create_by_auth(auth)
      sign_in(user)
    else
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
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end

  def errors
    @errors ||= {}
  end
end
