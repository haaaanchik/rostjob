class PagesController < ApplicationController
  include HighVoltage::StaticPage
  skip_before_action :auth_user
end
