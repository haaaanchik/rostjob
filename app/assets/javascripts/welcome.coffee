$(document).on('ajax:success', '.left-menu', (event) ->
  detail = event.detail
  xhr = detail[2]
  $('#right_window').html(xhr.response)
)
