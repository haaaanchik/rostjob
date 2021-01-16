# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  def completed
    @order = params[:order]
    customer_email = @order.user.email

    mail(to: customer_email, subject: 'RostJob. Заявка закрыта')
  end

  def published
    @order = params[:order]
    customer_email = @order.user.email

    mail(to: customer_email, subject: "RostJob. Заявка #{@order.title} успешно опубликована")
  end

  def moderated
    @order = params[:order]
    customer_email = @order.user.email

    mail(to: customer_email, subject: 'RostJob. Новая заявка на модерации')
  end

  def rejected
    @order = params[:order]
    customer_email = @order.user.email

    mail(to: customer_email, subject: 'RostJob. Заявка не прошла модерации')
  end
end
