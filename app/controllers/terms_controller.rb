class TermsController < ApplicationController

  def index
    @terms = Terms.new
    flash[:alert] = 'Вы должны принять условия оферты, прежде чем продолжить' unless current_user.terms_of_service
  end

  def accept
    @terms = Terms.new(terms_params)

    if @terms.valid? && current_user.accept_terms
      set_cookies_params(current_user)
      flash[:alert] = nil
      flash[:notice] = 'Условия оферты приняты!'
      redirect_to edit_user_registration_path
    else
      render :index
    end
  end

  private

  def terms_params
    params.require(:terms).permit(:accepted)
  end
end