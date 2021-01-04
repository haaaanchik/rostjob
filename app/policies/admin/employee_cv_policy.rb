# frozen_string_literal: true

class Admin::EmployeeCvPolicy < Admin::StafferPolicy
  def edit?
    allow_admin_and_moderator?
  end

  def update?
    edit?
  end
end
