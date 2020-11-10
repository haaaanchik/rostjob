class Profile::CandidatePolicy < ApplicationPolicy
  def show?
    customer?
  end

  def update?
    customer?
  end

  def hire?
    customer?
  end

  def fire?
    true
  end

  def destroy?
    true
  end

  def disput?
    customer?
  end

  def hd_correction?
    true
  end

  def reserve?
    true
  end

  def to_inbox?
    true
  end

  def to_interview?
    customer?
  end

  def transfer?
    customer?
  end
end