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
    @incident = params[:incident]

    mail(to: 'manager@rostjob.com', subject: 'Спор')
  end
end
