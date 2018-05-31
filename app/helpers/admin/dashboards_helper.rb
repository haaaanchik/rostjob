module Admin::DashboardsHelper
  def can_access?(roles = [])
    result = current_staffer.role_list & roles
    !result.empty?
  end
end
