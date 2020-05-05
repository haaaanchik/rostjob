class Profile::SettingsController < ApplicationController
  def index;end

  def update
    Cmd::Profile::Settings::Update.call(profile: current_user.profile, settings_hash: params[:settings])
  end
end