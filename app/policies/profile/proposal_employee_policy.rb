class Profile::ProposalEmployeePolicy < ApplicationPolicy
  def index?
    contractor?
  end

  def show?
    true
  end

  def create?
    index?
  end

  def new?
    true
  end

  def correct_interview_date?
    true
  end

  def to_disput?
    true
  end

  def revoke?
    index?
  end

  def approve_transfer?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end