$(document).on('click', '[for$=_tickets]', ->
  form = $('#ticket_search')[0]
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
