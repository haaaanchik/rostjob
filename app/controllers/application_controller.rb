class ApplicationController < BaseController
  include SessionsHelper
  include WordsHelper

  protect_from_forgery prepend: true
  before_action :set_raven_context
  # before_action :authenticate_user!
  before_action :left_menu_items
  before_action :auth_user
  before_action :ensure_cr_order_and_activate, if: :user_signed_in?
  before_action :create_profile, if: :user_signed_in_without_profile
  before_action :opened_tickets_count, if: :user_signed_in?
  before_action :p_employees_approved_count, if: :user_signed_in?
  before_action :set_user_info_to_cookies

  def create_profile
    redirect_to new_profile_path
  end

  def user_signed_in_without_profile
    user_signed_in? && !current_profile
  end

  private

  def auth_user
    redirect_to root_path unless user_signed_in?
  end

  def set_user_info_to_cookies
    user_signed_in? ? set_cookies_params(current_user) : delete_cookies_params
  end

  def ensure_cr_order_and_activate
    return if session_destroy_action?
    ensure_terms_acceptance &&
      ensure_password_changed &&
      ensure_profile_changed
  end

  def ensure_terms_acceptance
    redirect_to(terms_path) if !current_user.terms_of_service && params[:controller] != 'terms'
    current_user.terms_of_service
  end

  def ensure_password_changed
    if current_user.password_changed_at.nil? && not_password_edit_action?
      flash[:alert] = 'Пожалуйста установите имя и пароль'
      redirect_to edit_user_registration_path
    end
    current_user.password_changed_at
  end

  def ensure_profile_changed
    if current_profile.customer? && current_profile.updated_by_self_at.nil? && not_profile_edit_action?
      flash[:alert] = 'Пожалуйста заполните следующую информацию'
      redirect_to edit_profile_path
    end
  end

  def session_destroy_action?
    params[:controller] == 'users/sessions' && action_name == 'destroy'
  end

  def not_password_edit_action?
    !(params[:controller] == 'users/registrations' && %w(edit update).include?(params[:action]))
  end

  def not_profile_edit_action?
    !(params[:controller] == 'profiles' && %w(edit update).include?(params[:action]))
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

  def opened_tickets_count
    @opened_tickets_count = Ticket.with_other_tickets_for(current_user)
                                .opened
                                .without_waiting(current_profile)
                                .count
  end

  def p_employees_approved_count
    @p_employees_approved_count = ProposalEmployee.candidates(current_profile).approved.size
  end

  def left_menu_items
    @left_menu_items ||= Company.where.not(label: nil).pluck(:label).map(&:to_sym)
  end
end
