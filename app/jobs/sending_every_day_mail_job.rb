class SendingEveryDayMailJob < ApplicationJob
  queue_as :critical

  def perform
    today_interview
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
    ProposalEmployee.inbox.find_each(batch_size: 50).group_by(&:order_id).each do |_order_id, candidates|
      SendEveryDaysNotifyMailJob.perform_now(objects: candidates, method: 'candidates_inbox')
    end
  end

  def today_interview
    ProposalEmployee.where(interview_date: DateTime.now.beginning_of_day..DateTime.now.end_of_day)
      .group_by(&:order_id).each do |_order_id, prop_emp|
        NotifyMailer.with(prop_emps: prop_emp).today_interview.deliver_now
      end
  end
end