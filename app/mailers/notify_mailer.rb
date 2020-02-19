class NotifyMailer < ApplicationMailer

  def emp_cv_sended
    @employee_cv = params[:objects]
    customer_email = @employee_cv.order.user.email

    mail(to: customer_email, subject: 'RostJob. В заявку поступила анкета.')
  end

  def order_wait_for_payment
    @orders = params[:objects]
    email = @orders.first.user.email
    subject = @orders.size == 1 ? 'RostJob. Ожидаем оплату за заявку на' : 'RostJob. Ожидаем оплату за заявки на'

    mail(to: email, subject: "#{subject} #{Date.today}")
  end

  def invoce_wait_payment
    @invoices = params[:objects]
    email = @invoices.first.profile.user.email
    subject = @invoices.size == 1 ? 'RostJob. У вас есть неплаченный счёт на' : 'RostJob. У вас есть неплаченныe счёта на'

    mail(to: email, subject: "#{ subject }  #{ Date.today.to_s }")
  end

  def today_interview
    @prop_emps = params[:prop_emps]
    email = @prop_emps.first.order.user.email

    mail(to: email,
      subject: "RostJob. Собеседование на #{Date.today} ")
  end

  def candidates_inbox
    @candidates = params[:objects]
    email = @candidates.first.order.user.email

    mail(to: email, subject: "RostJob. У вас есть люди в очереди на #{Date.today}")
  end
end