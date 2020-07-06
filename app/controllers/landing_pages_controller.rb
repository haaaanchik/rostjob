class LandingPagesController < ActionController::Base
  layout 'secret_landing'

  before_action :set_user_new, only: %i[freelance industrial services professions]
  before_action :set_specializations, only: %i[industrial services]

  def freelance; end

  def industrial; end

  def services; end

  def professions; end

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

  def set_specializations
    @specializations = ActiveSpecializationsSpecification.to_scope
  end
end
