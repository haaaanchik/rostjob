class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :fill_profile

  def fill_profile
    return unless user_signed_in?
    return if request.fullpath.include?(destroy_user_session_path)
    request_path = URI(request.fullpath).path
    if !current_profile.filled? && (request_path != profile_path)
      redirect_to profile_path
    end
  end

  def current_profile
    @current_profile ||= current_user.profile
  end
end
