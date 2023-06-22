class LandingPagesController < ActionController::Base
  layout 'secret_landing'

  before_action :set_user_new, except: %i[request_call]
  before_action :set_specializations, only: %i[industrial services]

  def freelance; end

  def industrial; end

  def services; end

  def about_company; end

  def industry; end

  def professions
    @profession = Position.find_by(slug: params[:slug]).decorate
  end

  def contacts; end

  def request_call
    rnd = params["random"]
    captcha_resp = params["captcha"]["captcha"]
    if Captcha.check(captcha_resp, rnd)
      ContactUsMailer
        .with(username: params[:username], phone_number: params[:phone_number])
        .request_call
        .deliver_now

      redirect_to industrial_path, notice: 'Спасибо за заявку! Наш менеджер в ближайшее время свяжется с вами.'
    else
      redirect_to industrial_path, alert: 'Вы указали неверный код с картинки! Попробуйте снова.'
    end
  end

  private

  def set_user_new
    @user = User.new
  end

  def set_specializations
    @specializations = ActiveSpecializationsSpecification.to_scope
  end
end
