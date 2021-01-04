class Profile::BalancePolicy < ApplicationPolicy
  def show?
    contractor?
  end

  def withdrawal?
    contractor?
  end

  def withdrawal_methods?
    contractor?
  end

  def contractor_invoice?
    true
  end

  def destroy?
    true
  end
end