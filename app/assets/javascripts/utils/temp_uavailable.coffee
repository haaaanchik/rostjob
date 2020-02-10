$(document).on('click', '.tmp-unavailable, #add_column, #close-request, #info, #redact, .download-empl-cv', (event) ->
  event.preventDefault()
  toastr.info('Функционал временно недоступен')
)
