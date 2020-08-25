$(document).on('click', '.tmp-unavailable, #add_column, .download-empl-cv, #ticket-attach-file', (event) ->
  event.preventDefault()
  toastr.info('Функционал временно недоступен')
)
