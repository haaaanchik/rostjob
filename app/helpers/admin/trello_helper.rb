module Admin::TrelloHelper
  def custom_field_item(card, custom_field_id)
    custom_field_item = card.custom_field_items.find { |cfi| cfi.custom_field_id == custom_field_id }
    return if custom_field_item.nil?
    if custom_field_item.value.keys.include?('text')
      custom_field_item.value['text']
    else
      l(DateTime.parse(custom_field_item.value['date']), format: '%e %B %T %Y')
    end
  end
end
