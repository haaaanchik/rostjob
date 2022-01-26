# frozen_string_literal: true

module LandingPagesHelper
  def landing_main_path
    request.path.scan(/^\/\w+/).first
  end

  def landing_another_path(name)
    landing_main_path << name
  end

  def landing_registration_path
    return new_customer_path if landing_main_path == '/industrial'

    new_contractor_path
  end

  def class_recruiter
    'recruter-page' if current_user && current_profile&.contractor?
  end

  def work_results_last_month
    return fr_paid if fr_paid[:current_day].to_i == Date.today.day

    rewards_paid
    closed_orders
    reward_recruiters
    write_current_day
    fr_paid
  end

  def display_phone_number
    @display_phone_number ||= customer_or_recruiter_number
  end

  private

  def customer_or_recruiter_number
    return '8 (800) 700 53 17' if landing_main_path == '/freelance'

    '8 (800) 700-67-86'
  end

  def fr_paid
    @fr_paid ||= Redis::HashKey.new('freelance_rewards_paid')
  end

  def rewards_paid
    fr_paid[:reward_paid] ||= 7999500
    fr_paid[:reward_paid] = fr_paid[:reward_paid].to_i + 500
    fr_paid[:reward_paid] = 8900000 if fr_paid[:reward_paid].to_i > 13500000
  end

  def reward_recruiters
    fr_paid[:reward_recruiters] ||= 34
    fr_paid[:reward_recruiters] = fr_paid[:reward_recruiters].to_i + 1
    fr_paid[:reward_recruiters] = 35 if fr_paid[:reward_recruiters].to_i > 50
  end

  def closed_orders
    fr_paid[:closed_orders] ||= 799
    fr_paid[:closed_orders] = fr_paid[:closed_orders].to_i + 1
    fr_paid[:closed_orders] = 800 if fr_paid[:closed_orders].to_i > 1500
  end

  def write_current_day
    fr_paid[:current_day] = Date.today.day
  end
end
