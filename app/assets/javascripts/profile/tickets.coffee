$(document).on('click', '[for$=_tickets]', ->
  form = $('#ticket_search')[0]
  $(this).find('input').val()
  searchValue = $(this).find('input').val()
  $('#q_state_not_eq').val('closed') if searchValue == 'customer' || searchValue == 'contractor'
  setTimeout(
    ->
      form.submit()
    300
  )
)

$(document).on('click', '[for^=tickets_filter_]', ->
  form = $('#ticket_search')[0]
  setTimeout(
    ->
      form.submit()
    300
  )
)
