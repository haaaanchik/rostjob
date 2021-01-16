class SendingEveryDayMailCustomerJob < ApplicationJob
  queue_as :critical

  def perform
    today_interview_customer
    order_wait_for_payment
    invoice_wait_payment
    proposal_employee_inbox
    has_disputed_customer
    has_unaproved_acts
  end

  private

  def order_wait_for_payment
    Order.waiting_for_payment.includes(profile: :setting_objects).find_each(batch_size: 50).group_by(&:profile).each do |profile, orders|
      SendNotifyMailJob.perform_now(objects: orders, method: 'order_wait_for_payment') if profile.every_day_mailing?
    end
  end

  def invoice_wait_payment
    Invoice.created.customers.includes(profile: :setting_objects).find_each(batch_size: 50).group_by(&:profile).each do |profile, invoices|
      SendNotifyMailJob.perform_now(objects: invoices, method: 'invoce_wait_payment') if profile.every_day_mailing?
    end
  end

  def proposal_employee_inbox
    ProposalEmployee.inbox.includes(:order, profile: :setting_objects).group_by { |pr| pr.order.profile }.each do |profile, candidates|
      ProposalEmployeeMailJob.perform_now(proposal_employees: candidates, method: 'candidates_inbox') if profile.every_day_mailing?
    end
  end

  def today_interview_customer
    ProposalEmployee.interview.includes(:order, profile: :setting_objects).where('proposal_employees.interview_date <= ? ', DateTime.now.beginning_of_day)
      .group_by { |pr| pr.order.profile }.each do |profile, prop_emp|
        ProposalEmployeeMailJob.perform_now(proposal_employees: prop_emp, method: 'today_interview_customer') if profile.every_day_mailing?
      end
  end

  def has_disputed_customer
    ProposalEmployee.disputed.where(waiting: 'contractor').includes(:order, profile: :setting_objects).group_by { |pr| pr.order.profile }.each do |profile, prop_emp|
      ProposalEmployeeMailJob.perform_now(proposal_employees: prop_emp, method: 'informated_customer_has_disputed') if profile.every_day_mailing?
    end
  end

  def has_unaproved_acts
    ProposalEmployee.approved.includes(:order, profile: :setting_objects).group_by { |pr| pr.order.profile }.each do |profile, candidates|
      ProposalEmployeeMailJob.perform_now(proposal_employees: candidates, method: 'informated_customer_wait_aprove_act') if profile.every_day_mailing?
    end
  end
end