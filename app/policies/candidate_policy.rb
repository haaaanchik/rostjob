class CandidatePolicy < Struct.new(:user, :candidate)
  include Roles

  def index?
    customer?
  end

  def approval_list?
    customer?
  end

  def show?
    customer?
  end

  def comment?
    customer?
  end

  def revoke?
    true
  end

  def approve_all_acts?
    customer?
  end

  def approve_act?
    customer?
  end
end