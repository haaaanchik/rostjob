module RolesHelper
  def customer?
    employer? || agency?
  end

  def executor?
    agency? || recruiter?
  end

  def employer?
    profile_type == 'employer'
  end

  def agency?
    profile_type == 'agency'
  end

  def recruiter?
    profile_type == 'recruiter'
  end

  def employee?
    profile_type == 'employee'
  end

  def profile_type
    current_user.profile.profile_type
  end
end
