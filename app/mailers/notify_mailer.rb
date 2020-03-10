class NotifyMailer < ApplicationMailer

  def emp_cv_sended
    @employee_cv = params[:objects]
    customer_email = @employee_cv.order.user.email

    mail(to: customer_email, subject: 'RostJob. В заявку поступила анкета.')
  end

  def order_wait_for_payment
    @orders = params[:objects]
    customer_email = @orders.first.user.email
    subject = @orders.size == 1 ? 'RostJob. У вас есть неоплаченная заявка' : 'RostJob. У вас есть неоплаченные заявки'

    mail(to: customer_email, subject: subject)
  end

  def invoce_wait_payment
    @invoices = params[:objects]
    customer_email = @invoices.first.profile.user.email
    subject = @invoices.size == 1 ? 'RostJob. У вас есть неоплаченный счёт' : 'RostJob. У вас есть неоплаченные счёта'

    mail(to: customer_email, subject: subject)
  end

  def today_interview_customer
    @prop_emps = params[:proposal_employees]
    customer_email = @prop_emps.first.order.user.email

    mail(to: customer_email,
      subject: 'RostJob. Собеседования на сегодня')
  end

  def candidates_inbox
    @candidates = params[:proposal_employees]
    email = @candidates.first.order.user.email
    subject = @candidates.size == 1 ? 'RostJob. Кандидат ждёт назначения собеседования.' : 'RostJob. Кандидаты ждут назначения собеседования.'

    mail(to: email, subject: subject)
  end

  def tommorow_interview_customer
    @prop_emps = params[:proposal_employees]
    customer_email = @prop_emps.first.order.user.email

    mail(to: customer_email,
      subject: 'RostJob. У вас завтра собеседование.')
  end

  def tommorow_interview_contractor
    @prop_emps = params[:proposal_employees]
    contractor_email = @prop_emps.first.profile.user.email
    subject = @prop_emps.size == 1 ? 'RostJob. У Вашего кандидата завтра собеседование.' : 'RostJob. У Ваших кандидатов завтра собеседования.'

    mail(to: contractor_email, subject: subject)
  end

  def proposal_employee_hired
    @prop_emp = params[:proposal_employees].first
    contractor_email = @prop_emp.profile.user.email

    mail(to: contractor_email, subject: 'RostJob. Ваш кандидат нанят.')
  end

  def informated_contractor_about_interview
    @prop_emp = params[:proposal_employees].first
    contractor_email = @prop_emp.profile.user.email

    mail(to: contractor_email, subject: 'RostJob. Ваш кандидат приглашен на собеседование.')
  end

  def informated_contractor_has_paid
    @prop_emp = params[:proposal_employees].first
    contractor_email = @prop_emp.profile.user.email

    mail(to: contractor_email, subject: 'RostJob. Вы получили вознаграждение')
  end

  def informated_contractor_has_disputed
    @incidents = params[:objects]
    contractor_email = @incidents.first.proposal_employee.profile.user.email

    subject = @incidents.size > 1 ? 'RostJob. Уведомление об открытых спорах' : 'RostJob. Уведомление об открытом споре'

    mail(to: contractor_email, subject: subject)
  end

  def informated_customer_has_disputed
    @prop_emp = params[:proposal_employees]
    contractor_email = @prop_emp.first.profile.user.email

    subject = @prop_emp.size > 1 ? 'RostJob. Уведомление об открытых спорах' : 'RostJob. Уведомление об открытом споре'

    mail(to: contractor_email, subject: subject)
  end
end