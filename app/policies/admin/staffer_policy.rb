# frozen_string_literal: true

class Admin::StafferPolicy < ApplicationPolicy
  def index?
    allow_admin_and_moderator?
  end

  private

  def allow_admin_and_moderator?
    return false if user.seo?

    true
  end

  def super_admin?
    user.super_admin?
  end
end
