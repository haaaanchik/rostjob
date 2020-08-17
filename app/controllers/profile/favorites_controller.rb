class Profile::FavoritesController < ApplicationController
  def index
    @active_item = :favorites
    favorites.decorate
  end

  def search_orders
    favorites.decorate
  end

  private

  def employee_cv_id
    @employee_cv_id = params[:employee_cv_id]
  end

  def favorites
    @q ||= if employee_cv_id
             current_profile.favorites.published.with_customer_name.order(urgency_level: :desc, created_at: :desc).ransack(params[:q])
           else
             current_profile.favorites.with_customer_name.order(urgency_level: :desc, created_at: :desc).ransack(params[:q])
           end
    @favorites ||= @q.result
  end
end
