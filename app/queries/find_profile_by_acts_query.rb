# frozen_string_literal: true

class FindProfileByActsQuery
  attr_accessor :scope, :profile, :params

  def initialize(scope, profile, params = {})
    @scope = scope
    @profile = profile
    @params = params
  end

  def call
    return profile if profile_id.blank? || scope.blank?

    scope
      .object
      .find_by(id: profile_id)
      &.decorate
  end

  private

  def profile_id
    params[:profile_id]
  end
end
