# frozen_string_literal: true

class AnalyticsProductionSitesSpecification
  class << self
    def to_scope
      ProductionSite
        .select(:id, :title, :profile_id, :city, :created_at, 'users.full_name as owner_name')
        .joins(:user)
        .order(:profile_id)
    end
  end
end