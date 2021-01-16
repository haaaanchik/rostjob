class DirectMailMailer < ApplicationMailer
  def custom_message
    @user = params[:user]
    @message = params[:message]
    mail(to: @user.email, subject: params[:subject])
  end

  def welcome_message
    @user = params[:user]

    mail(to: @user.email, subject: 'RostJob. Добро пожаловать!')
  end

  def deposite_was_upped
    @user = params[:user]
    @value_to_upped = params[:attrs][:amount]

    mail(to: @user.email, subject: 'RostJob. Вы пополнили баланс.')
  end

  def mail_about_close_incident
    @user = params[:user]
    @message = params[:message]
    @incident = params[:attrs][:incident]
    @ticket = params[:attrs][:ticket]

    mail(to: @user.email, subject: 'RostJob. Спор был закрыт.')
  end

  def informated_about_revoke
    @user = params[:user]
    @prop_emp = params[:attrs][:proposal_employee]
    @by_admin = params[:attrs][:by_admin]

    mail(to: @user.email, subject: 'RostJob. Анкета кандидата была отозвана.')
  end

  def informated_admin_about_precedent
    @incident = params[:attrs][:incident]

    mail(to: 'manager@rostjob.com', subject: "RostJob. Нерешенный конфликт #{@incident.id}.")
  end

  def informated_about_failed_interview
    @user = params[:user]
    @message = params[:message]
    @proposal_employee = params[:attrs][:proposal_employee]

    mail(to: @user.email, subject: "RostJob. Кандидату было отказано.")
  end

  def informated_admin_about_revoke
    @incident = params[:attrs][:incident]
    @message  = params[:attrs][:message]

    mail(to: 'manager@rostjob.com', subject: "RostJob. Нерешенный конфликт #{@incident.id}.")
  end
end
