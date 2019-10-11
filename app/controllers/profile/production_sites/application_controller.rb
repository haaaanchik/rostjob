class Profile::ProductionSites::ApplicationController < ApplicationController
  private

  def production_site
    @production_site ||= current_profile.production_sites.find(params[:production_site_id])
  end
end
