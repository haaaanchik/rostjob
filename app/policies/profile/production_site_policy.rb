class Profile::ProductionSitePolicy < ApplicationPolicy
  def index?
    customer?
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def edit?
    index?
  end

  def update?
    index?
  end

  def show?
    index?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
