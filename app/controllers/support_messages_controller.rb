class SupportMessagesController < ApplicationController
  def new
    @message_to_support = MessageToSupport.new
  end

  def create
    @message_to_support = MessageToSupport.new(permitted_params)
    if verify_recaptcha(model: @message_to_support, attribute: :recaptcha) &&
       @message_to_support.save
      SendMailJob.perform_later(message: @message_to_support)
      redirect_to root_path
    else
      render json: { errors: @message_to_support.errors.messages }
    end
  end

  private

  def permitted_params
    params.require(:message_to_support).permit(:sender_name, :email_address, :text)
  end
end
