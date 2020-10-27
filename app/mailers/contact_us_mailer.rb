class ContactUsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_us_mailer.send_notification.subject
  #
  def send_notification
    message = params[:message]
    @sender_name = message.sender_name
    @email_address = message.email_address
    @text = message.text

    mail to: Rails.application.config.email_to
  end

  def admin_dispute_notification
    @message = params[:message]
    @incident = params[:attrs][:incident]

    mail(to: 'manager@rostjob.com', subject: 'RostJob. Спор')
  end

  def request_call
    @username = params[:username]
    @phone_number = params[:phone_number]

    mail(to: ['manager@rostjob.com', 'msk@rostjob.com', 'spb@rostjob.com'], subject: 'RostJob. Заявка на бесплатную консультацию')
  end
end
