# frozen_string_literal: true

class Admin::MailsController < Admin::ApplicationController
  def new
    @order_wait_payment = Order.waiting_for_payment
    @invoice_wait_payment = Invoice.created
    @sended_employ_cv =   EmployeeCv.sent
    @today_interview = ProposalEmployee.interview.where(interview_date: DateTime.now.beginning_of_day).includes(:employee_cv, :order)
  end

  def create
    MailsForGroupJob.perform_now(profile_type: params[:mail][:group_category],
                                 subject: params[:mail][:subject],
                                 message: params[:mail][:text],
                                 email: params[:mail][:email])
    redirect_back(fallback_location: root_path)
  end

  def send_mail_order_wait_payment
    Order.find(params[:order_id]).send_mail_wait_for_payment
    redirect_back(fallback_location: root_path)
  end

  def send_mail_invoice_wait_payment
    Invoice.find(params[:invoice_id]).send_mail_wait_for_payment
    redirect_back(fallback_location: root_path)
  end

  def send_mail_employee_sent
    EmployeeCv.find(params[:employee_id]).mail_with_to_sent
    redirect_back(fallback_location: root_path)
  end

  def send_notify_interview
    ProposalEmployee.find(params[:proposal_employee_id]).mail_interview_customer
    redirect_back(fallback_location: root_path)
  end
end
