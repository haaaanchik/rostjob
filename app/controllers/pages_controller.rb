class PagesController < ApplicationController
  include HighVoltage::StaticPage
  skip_before_action :auth_user
  before_action :check_access_as_an_individual

  private

  def check_access_as_an_individual
    return unless current_page == 'pages/as_an_individual'
    redirect_to root_path, alert: 'У вас нет доступа к странице.' unless user_signed_in? && current_profile.contractor?
  end
end
