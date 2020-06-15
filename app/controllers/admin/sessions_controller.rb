class Admin::SessionsController < Admin::ApplicationController
  skip_before_action :set_authorize

  def new; end

  def create
    staffer = Staffer.find_by(login: params[:login])
    if staffer && staffer.authenticate(params[:password])
      sign_in(staffer)
      redirect_to admin_path
    else
      redirect_to admin_login_path
    end
  end

  def destroy
    sign_out
    redirect_to admin_login_path
  end
end
