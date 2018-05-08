class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
     @user = User.find_or_register_facebook_oauth request.env["omniauth.auth"]
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Vkontakte"
      sign_in @user
      if !@user.profile.filled?
        redirect_to profile_path
      else
        redirect_to root_path
      end
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
 end

  def vkontakte
    @user = User.find_or_register_vkontakte_oauth request.env["omniauth.auth"]
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Vkontakte"
      sign_in @user
      if !@user.profile.filled?
        redirect_to profile_path
      else
        redirect_to root_path
      end
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end
end
