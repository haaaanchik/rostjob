class Admin::ApplicationController < BaseController
  include Admin::SessionsHelper

  protect_from_forgery prepend: true

  before_action :authenticate_staffer!

  layout 'admin'
end
