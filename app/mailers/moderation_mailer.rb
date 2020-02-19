class ModerationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_us_mailer.send_notification.subject
  #
  def send_notification
    @order = params[:order]
    mail(to: Rails.configuration.moderation_email_to, subject: 'RostJob. Вашу заявку просматривает администрация сайта.')
  end
end
