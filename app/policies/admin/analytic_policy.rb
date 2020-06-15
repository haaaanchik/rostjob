# frozen_string_literal: true

class Admin::AnalyticPolicy < ApplicationPolicy
  def orders_info?
    true
  end
end
