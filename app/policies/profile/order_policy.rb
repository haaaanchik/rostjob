class Profile::OrderPolicy < ApplicationPolicy
  def index?
    customer?
  end

  def show?
    index?
  end

  def update?
    index?
  end

  def update_pre_publish?
    index?
  end

  def pre_publish?
    index?
  end

  def publish?
    index?
  end

  def hide?
    index?
  end

  def complete?
    index?
  end

  def cancel?
    index?
  end

  def add_position?
    index?
  end

  def move?
    index?
  end

  def add_additional_employees?
    index?
  end

  def first_step?
    index?
  end

  def second_step?
    index?
  end

  def third_step?
    index?
  end
end