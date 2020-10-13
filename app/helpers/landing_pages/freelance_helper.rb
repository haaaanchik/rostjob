# frozen_string_literal: true

module LandingPages::FreelanceHelper
  def work_results_last_month
    return fr_paid if fr_paid[:current_day].to_i == Date.today.day

    rewards_paid
    closed_orders
    reward_recruiters
    write_current_day
    fr_paid
  end

  private

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
