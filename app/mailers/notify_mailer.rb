# frozen_string_literal: true

class NotifyMailer < ApplicationMailer
  def emp_cv_sended
    @proposal_employee = params[:objects].first
    customer_email = @proposal_employee.order.user.email

    mail(to: customer_email, subject: "RostJob. В заявку №#{@proposal_employee.order.id} #{@proposal_employee.order.title} поступила анкета.")
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
    subject = @prop_emps.size == 1 ? 'RostJob. Собеседование сегодня' : 'RostJob. Собеседования на сегодня'

    mail(to: customer_email, subject: subject)
  end

  def candidates_inbox
    @candidates = params[:proposal_employees]
    email = @candidates.first.order.user.email
    subject = @candidates.size == 1 ? 'RostJob. Кандидат ждёт назначения собеседования.' : 'RostJob. Кандидаты ждут назначения собеседования.'

    mail(to: email, subject: subject)
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

  def informate_about_interview
    @user = params[:user]
    @pr_emp = params[:proposal_employees].first

    subject = @user.customer? ? 'RostJob. Рекрутер скорректировал дату собеседования.' : 'RostJob. Ваш кандидат приглашен на собеседование.'
    mail(to: @user.email, subject: subject)
  end

  def informated_contractor_has_paid
    @prop_emp = params[:proposal_employees].first
    contractor_email = @prop_emp.profile.user.email

    mail(to: contractor_email, subject: 'RostJob.')
  end

  def informated_user_has_disputed
    @pr_empls = params[:proposal_employees]
    @user = params[:user]

    subject = @pr_empls.size > 1 ? 'RostJob. Уведомление об открытых спорах' : 'RostJob. Уведомление об открытом споре'
    mail(to: @user.email, subject: subject)
  end

  def informated_customer_wait_aprove_act
    @prop_emps = params[:proposal_employees]
    customer_email = @prop_emps.first.order.profile.user.email

    subject = @prop_emps.size > 1 ? 'RostJob. Уведомление об неподтвержденных актах' : 'RostJob. Уведомление об неподтвержденном акте'

    mail(to: customer_email, subject: subject)
  end

  def notify_contractor_about_new_resume
    @employee_cv = params[:employee_cv]
    @order_city = params[:order_city]
    @order_title = params[:order_title]

    subject = 'RostJob. Отклик на вакансию'

    mail(to: @employee_cv.profile.user.email, subject: subject)
  end
end