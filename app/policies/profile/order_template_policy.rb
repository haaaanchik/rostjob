class Profile::OrderTemplatePolicy < ApplicationPolicy
  def create?
    customer?
  end

  def update?
    customer?
  end

  def save_name?
    true
  end

  def destroy?
    custromer?
  end

  def destroy_array?
    true
  end

  def copy?
    true
  end

  def move?
    customer?
  end

  def second_step?
    customer?
  end

  def third_step?
    customer?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end