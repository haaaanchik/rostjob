# frozen_string_literal: true

class ProfilesWithCurrentActsQuery
  attr_accessor :profile

  def initialize(profile)
    @profile = profile
  end

  def call
    Profile
      .joins(proposal_employees: :order)
      .where('proposal_employees.state': 'approved',
             'orders.profile_id': profile.id )
      .distinct
      .includes(:user)
      .decorate
  end
end
