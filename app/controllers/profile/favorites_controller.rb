class Profile::FavoritesController < ApplicationController
  def index
    favorites
    @employee_cv_id = employee_cv_id
    @order_search_form = OrderSearchForm.new
    @active_item = :favorites
  end

  private

  def employee_cv_id
    params[:employee_cv_id]
  end

  def favorites
    @favorites ||= if employee_cv_id
                     current_profile.favorites.published.order(urgency_level: :desc, created_at: :desc).decorate
                   else
                     current_profile.favorites.order(urgency_level: :desc, created_at: :desc).decorate
                   end
  end
end
