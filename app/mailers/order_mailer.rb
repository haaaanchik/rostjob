class OrderMailer < ApplicationMailer
  def completed
    @order = params[:order]
    customer_email = @order.user.email

    mail(to: customer_email, subject: 'Заявка закрыта')
  end

  def published
    @order = params[:order]
    customer_email = @order.user.email

    mail(to: customer_email, subject: 'Заявка открыта')
  end
end
