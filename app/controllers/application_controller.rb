class ApplicationController < BaseController
  include SessionsHelper
  include WordsHelper

  protect_from_forgery prepend: true
  before_action :set_raven_context
  before_action :authenticate_user!
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

  def set_raven_context
    # Raven.user_context(id: session[:current_user_id]) # or anything else in session
    ::Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def errors_data(obj)
    errors_data = {}
    prefix = obj.class.to_s.downcase
    errors = obj.errors.messages
    errs = errors.map do |err|
      [err.first.to_s, err.last.first]
    end
    errs.map do |err|
      err_keys = err.first.split('.')
      field_name = "_#{err_keys.pop}"
      err_keys.map! do |ek|
        if plural?(ek)
          "#{ek}_attributes_0"
        else
          "#{ek}_attributes"
        end
      end
      err_path = err_keys.any? ? "_#{err_keys.join('_')}" : ''
      errors_data["#{prefix}#{err_path}#{field_name}"] = err.last
    end
    errors_data
  end
end
