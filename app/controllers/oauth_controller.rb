class OauthController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  skip_before_action :create_profile

  def create
    user = User.find_or_create_by_auth(auth)
    sign_in(user)
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
