class Profile::FavoritesController < ApplicationController
  def index
    favorites
    @employee_cv_id = params[:employee_cv_id]
    @order_search_form = FavoritesSearchForm.new(favorites_search_form_params)
    @orders = @order_search_form.submit
  end

  private

  def favorites
    @favorites ||= current_profile.favorites.decorate
  end

  def favorites_search_form_params
    params.permit(favorites_search_form: :query)[:order_search_form]
  end
end
