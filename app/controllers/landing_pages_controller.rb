class LandingPagesController < ActionController::Base
  layout 'application'

  before_action :set_user_new, only: %i[new_contractor new_customer freelance industrial]
  before_action :set_secret_landing, only: %i[freelance]

  def new_contractor; end

  def new_customer; end

  def freelance; end

  def industrial
    @specializations = ActiveSpecializationsSpecification.to_scope
    set_secret_landing
  end

  def request_call
    ContactUsMailer
      .with(username: params[:username], phone_number: params[:phone_number])
      .request_call
      .deliver_now

    redirect_to industrial_path, notice: 'Спасибо за заявку! Наш менеджер в ближайшее время свяжется с вами.'
  end

  private

  def set_user_new
    @user = User.new
  end

  def set_secret_landing
    render layout: 'secret_landing'
  end
end
