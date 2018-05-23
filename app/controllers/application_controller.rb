class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :set_raven_context
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

  private

  def set_raven_context
    # Raven.user_context(id: session[:current_user_id]) # or anything else in session
    ::Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
