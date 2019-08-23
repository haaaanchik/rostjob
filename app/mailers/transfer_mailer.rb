class TransferMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_us_mailer.send_notification.subject
  #
  def send_notification
    @candidate = params[:candidate]
    @employee_cv = @candidate.employee_cv
    email = @candidate.profile.user.email

    mail(to: email, subject: "Анкета #{@employee_cv.id} #{@employee_cv.name} переносится в заявку №#{@candidate.dst_order_id}")
  end
end
