$(document).on('click', '.tmp-unavailable, .download-empl-cv, #ticket-attach-file', (event) ->
  event.preventDefault()
  toastr.info('Функционал временно недоступен')
)
