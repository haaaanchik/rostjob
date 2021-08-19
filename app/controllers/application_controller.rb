class ApplicationController < BaseController
  include SessionsHelper
  include WordsHelper

  rescue_from Pundit::NotAuthorizedError, with: :redirect_back_with_message
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_back_with_message

  protect_from_forgery prepend: true
  # before_action :set_raven_context
  # before_action :authenticate_user!
  before_action :left_menu_items
  before_action :auth_user
  before_action :ensure_cr_order_and_activate, if: :user_signed_in?
  before_action :opened_tickets_count, if: :user_signed_in?
  before_action :p_employees_approved_count, if: :user_signed_in?
  before_action :set_user_info_to_cookies
  helper_method :current_profile

  def current_profile
    @current_profile ||= current_user.profile
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
      flash[:alert] = 'Пожалуйста установите имя, номер телефона и пароль'
      redirect_to edit_user_registration_path
    end
    current_user.password_changed_at
  end

  def ensure_profile_changed
    if current_profile.updated_by_self_at.nil? && not_profile_edit_action?
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
    @opened_tickets = Ticket.with_other_tickets_for(current_user)
                          .opened
                          .without_waiting(current_profile)
    @opened_tickets_count = @opened_tickets.count
  end

  def p_employees_approved_count
    @p_employees_approved_count = ProposalEmployee.candidates(current_profile).approved.size
  end

  def left_menu_items
    @left_menu_items ||= Company.where.not(label: nil).pluck(:label).map(&:to_sym)
  end

  def redirect_back_with_message
    flash[:alert] = 'Страница недоступна'
    redirect_back(fallback_location: root_path)
  end
end
