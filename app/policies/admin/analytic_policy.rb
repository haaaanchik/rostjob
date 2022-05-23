# frozen_string_literal: true

class Admin::AnalyticPolicy < Admin::StafferPolicy
  def export_to_excel?
    allow_admin_and_moderator?
  end

  def orders_info?
    true
  end

  def user_action_log?
    orders_info?
  end

  def user_activity?
    orders_info?
  end
end
