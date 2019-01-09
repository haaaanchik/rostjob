class ApplicationController < BaseController
  include SessionsHelper
  include WordsHelper

  protect_from_forgery prepend: true
  before_action :set_raven_context
  before_action :authenticate_user!
  before_action :auth_user
  before_action :create_profile, if: :user_signed_in_without_profile

  def create_profile
    redirect_to new_profile_path
  end

  def user_signed_in_without_profile
    user_signed_in? && !current_profile
  end

  def current_profile
    @current_profile ||= current_user.profile
  end

  private

  def auth_user
    redirect_to root_path unless user_signed_in?
  end

  def error_msg_handler(object)
    html = 'При сохранении произошли следующие ошибки: <br/>'
    object.errors.full_messages.each do |msg|
      html += "#{msg} <br/>"
    end
    html.html_safe
  end

  def set_raven_context
    # Raven.user_context(id: session[:current_user_id]) # or anything else in session
    # ::Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
