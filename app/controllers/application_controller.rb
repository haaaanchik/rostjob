class ApplicationController < ActionController::Base
  def current_profile
    @current_profile ||= current_user.profile
  end
end
