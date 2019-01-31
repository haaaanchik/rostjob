class Profile::FavoritesController < ApplicationController
  def index
    favorites
    @employee_cv_id = params[:employee_cv_id]
  end

  private

  def favorites
    @favorites ||= current_profile.favorites.decorate
  end
end
