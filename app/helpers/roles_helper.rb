module RolesHelper
  def customer?
    profile_type == 'customer'
  end

  def contractor?
    profile_type == 'customer'
  end

  def profile_type
    current_user.profile.profile_type
  end
end
