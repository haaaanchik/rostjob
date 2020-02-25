class Profile::ProductionSites::ApplicationController < ApplicationController
  before_action :set_resource, only: %i[first_step second_step third_step]

  def first_step
    @model_resource.creation_step = 1
    render_template
  end

  def second_step
    @model_resource.creation_step = 2
    render_template
  end

  def third_step
    @model_resource.creation_step = 3
    render_template
  end

  private

  def production_site
    @production_site ||= current_profile.production_sites.find(params[:production_site_id])
  end

  def render_template
    render template: "profile/production_sites/#{@model_resource.class.table_name.singularize}s/form"
  end
end
