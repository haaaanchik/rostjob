class InvoicePolicy < ApplicationPolicy
  def index?
    customer?
  end

  def create?
    customer?
  end

  def show?
    customer?
  end

  def destroy?
    customer?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end