# frozen_string_literal: true

class Admin::SpecializationPolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def edit?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end
end
