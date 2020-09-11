# frozen_string_literal: true

class Admin::ProductionSitePolicy < Admin::StafferPolicy 
  def index?
    allow_admin_and_moderator?
  end

  def update?
    allow_admin_and_moderator?
  end

  def destroy?
    allow_admin_and_moderator?
  end
end