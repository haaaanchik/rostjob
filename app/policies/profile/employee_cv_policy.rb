class Profile::EmployeeCvPolicy < ApplicationPolicy
  def index?
    contractor?
  end

  def new?
    index?
  end

  def update?
    index?
  end

  def create_as_ready?
    index?
  end

  def create_for_send?
    index?
  end

  def update?
    index?
  end

  def reset_reminder?
    true
  end

  def destroy?
    index?
  end

  def change_status?
    true
  end

  def to_ready?
    true
  end

  def to_disput?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end