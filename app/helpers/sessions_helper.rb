module SessionsHelper
  # def current_user
  #   @current_user ||= User.find_by(guid: session[:user_guid]) if session[:user_guid]
  # end

  # def authenticate_user!
  #   redirect_to login_path unless current_user
  # end

  # def sign_in(user)
  #   session[:user_guid] = user.guid
  #   user.update_attribute(:last_sign_in_at, Time.now)
  # end
  #
  # def user_signed_in?
  #   session[:user_guid] && User.find_by(guid: session[:user_guid]) ? true : false
  # end
  #
  # def sign_out
  #   session[:user_guid] = nil
  # end
end
