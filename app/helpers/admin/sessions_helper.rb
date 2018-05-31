module Admin::SessionsHelper
  def current_staffer
    @current_staffer ||= Staffer.find_by(guid: session[:staffer_guid]) if session[:staffer_guid]
  end

  def authenticate_staffer!
    redirect_to admin_login_path unless current_staffer ||
                                        request.fullpath.include?(admin_login_path) ||
                                        request.fullpath.include?(admin_logout_path)
  end

  def sign_in(staffer)
    session[:staffer_guid] = staffer.guid
  end

  def staffer_signed_in?
    session[:staffer_guid] && Staffer.find_by(guid: session[:staffer_guid])
  end

  def sign_out
    session[:staffer_guid] = nil
  end
end
