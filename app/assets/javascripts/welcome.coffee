$(document).on('ajax:success', '.left-menu', (event) ->
  detail = event.detail
  xhr = detail[2]
  $('#main_row').html(xhr.response)
)
