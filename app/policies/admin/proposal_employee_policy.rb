# frozen_string_literal: true

class Admin::ProposalEmployeePolicy < Admin::StafferPolicy

  def index?
    allow_admin_and_moderator?
  end

  def revoke?
    allow_admin_and_moderator?
  end

  def hire?
    revoke?
  end

  def approve?
    revoke?
  end

  def paid?
    revoke?
  end

  def approval_list?
    allow_admin_and_moderator?
  end

  def approve_act?
    allow_admin_and_moderator?
  end
end
