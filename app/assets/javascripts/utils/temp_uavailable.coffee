$(document).on('click', '.tmp-unavailable, #add_column, #close-request, #info, #redact, .download-empl-cv, #add_ancete, .add_ancete_close', (event) ->
  event.preventDefault()
  toastr.info('Функционал временно недоступен')
)
