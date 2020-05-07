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
end