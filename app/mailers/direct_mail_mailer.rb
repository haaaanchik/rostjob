class DirectMailMailer < ApplicationMailer
  def custom_message
    @user = params[:user]
    @message = params[:message]
    mail(to: @user.email, subject: params[:subject])
  end
end