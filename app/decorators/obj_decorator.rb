class ObjDecorator < ApplicationDecorator
  delegate_all

  def display_rating
    min_rating = object.is_a?(Profile) && contractor? ? 0.0 : 5.0
    return 'Нет данных' if rating <= min_rating
    "#{rating}/10"
  end

  def display_deal_counter
    return 'Нет данных' if deal_counter == 0
    deal_counter
  end
end
