class ObjDecorator < ApplicationDecorator
  delegate_all

  def display_rating
    return 'Нет данных' if rating == 0.0
    "#{rating}/10"
  end

  def display_deal_counter
    return 'Нет данных' if deal_counter == 0
    deal_counter
  end
end
