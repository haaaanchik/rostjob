# frozen_string_literal: true

class Admin::StafferPolicy < ApplicationPolicy
  def index?
    allow_admin_and_moderator?
  end

  private

  def allow_admin_and_moderator?
    user.admin? || user.moderator?
  end
end
