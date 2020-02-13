class ApplicationMailer < ActionMailer::Base
  # default from: 'noreply@rostjob.com'
  add_template_helper(EmailHelper)
  layout 'mailer'
end
