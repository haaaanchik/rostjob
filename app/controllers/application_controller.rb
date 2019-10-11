class ApplicationController < BaseController
  include SessionsHelper
  include WordsHelper

  protect_from_forgery prepend: true
  before_action :set_raven_context
  # before_action :authenticate_user!
  before_action :left_menu_items
  before_action :auth_user
  before_action :create_profile, if: :user_signed_in_without_profile
  before_action :opened_tickets_count, if: :user_signed_in?

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

  def left_menu_items
    @left_menu_items ||= Company.where.not(label: nil).pluck(:label).map(&:to_sym)
  end
end
