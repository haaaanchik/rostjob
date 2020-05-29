# frozen_string_literal: true

class ActsByProfileQuery
  attr_accessor :scope, :params

  def initialize(scope)
    @scope = scope
  end

  def call
    return [] if scope.blank?

    scope
      .proposal_employees
      .approved
      .includes(:order)
  end
end
