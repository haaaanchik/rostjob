class SendingEveryDayMailCustomerJob < ApplicationJob
  queue_as :critical

  def perform
    today_interview_customer
    tomorrow_inteview_customer
    order_wait_for_payment
    invoice_wait_payment
    proposal_employee_inbox
  end

  private

  def order_wait_for_payment
    Order.waiting_for_payment.find_each(batch_size: 50).group_by(&:profile_id).each do |_profile_id, orders|
      SendEveryDaysNotifyMailJob.perform_now(objects: orders, method: 'order_wait_for_payment')
    end
  end

  def invoice_wait_payment
    Invoice.created.customers.find_each(batch_size: 50).group_by(&:profile_id).each do |_profile_id, invoices|
      SendEveryDaysNotifyMailJob.perform_now(objects: invoices, method: 'invoce_wait_payment')
    end
  end

  def proposal_employee_inbox
    ProposalEmployee.inbox.includes(:order).group_by { |pr| pr.order.profile_id }.each do |_profile_id, candidates|
      ProposalEmployeeMailJob.perform_now(proposal_employees: candidates, method: 'candidates_inbox')
    end
  end

  def today_interview_customer
    ProposalEmployee.interview.includes(:order).where(interview_date: DateTime.now.beginning_of_day)
      .group_by { |pr| pr.order.profile_id }.each do |_profile_id, prop_emp|
        ProposalEmployeeMailJob.perform_now(proposal_employees: prop_emp, method: 'today_interview_customer')
      end
  end

  def tomorrow_inteview_customer
    ProposalEmployee.interview.includes(:order).where(interview_date: (DateTime.now.beginning_of_day + 1.day))
      .group_by { |pr| pr.order.profile_id }.each do |_profile_id, prop_emp|
        ProposalEmployeeMailJob.perform_now(proposal_employees: prop_emp, method: 'tommorow_interview_customer')
      end
  end
end