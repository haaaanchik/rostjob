@save_current_price_group_id = (event) ->
  select = $(event.currentTarget)
  select.data('prev-id', select.val())

@update_position = (event) ->
  select = $(event.currentTarget)
  position_id = select.data('position-id')
  confirm_message = select.data('confirm')
  option = $('option:selected', select)
  title = option.text()
  price_group_id = select.val()
  result = window.confirm("Уверены что хотите перевести должность в ценовую группу '#{title}'?")
  if result
    select.parent('form').submit()
  else
    prev_id = select.data('prev-id')
    select.val(prev_id)
