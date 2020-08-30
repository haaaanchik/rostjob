class TermsController < ApplicationController
  skip_before_action :auth_user, only: %i[download]

  def index
    @terms = Terms.new
    @profile_type = current_profile.profile_type
    flash[:alert] = 'Вы должны принять условия оферты, прежде чем продолжить' unless current_user.terms_of_service
    respond_to do |format|
      format.html
      format.pdf { render pdf_setting }
    end
  end

  def accept
    @terms = Terms.new(terms_params)

    if @terms.valid? && current_user.accept_terms
      flash[:alert] = nil
      flash[:notice] = 'Условия оферты приняты!'
      redirect_to edit_user_registration_path
    else
      redirect_to terms_path
    end
  end

  def download
    @profile_type = 'customer'
    respond_to do |format|
      format.html
      format.pdf { render pdf_setting }
    end
  end

  private

  def terms_params
    params.require(:terms).permit(:accepted)
  end

  def pdf_setting
    {
      pdf: 'договор оферты RostJob',
      template: 'terms/_term_pdf.html',
      orientation: 'Portrait',
      page_size: 'A4',
      dpi: 300,
      encoding: 'utf-8'
    }
  end
end