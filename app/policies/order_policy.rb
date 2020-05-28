class OrderPolicy < ApplicationPolicy
  def index?
    contractor?
  end

  def customer_orders?
    contractor?
  end

  def add_to_favorites?
    contractor?
  end

  def remove_from_favorites?
    contractor?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end