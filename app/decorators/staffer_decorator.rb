class StafferDecorator < ApplicationDecorator
  delegate_all

  def full_name
    model.name
  end
end
