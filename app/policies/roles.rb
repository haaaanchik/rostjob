module Roles
  def customer?
    user.profile.customer?
  end

  def contractor?
    user.profile.contractor?
  end

  def client?
    customer? || contractor?
  end

  def owner?
    record.profile == user.profile
  end

  def customer_and_owner?
    customer? && owner?
  end

  def contractor_and_owner?
    contractor? && owner?
  end
end