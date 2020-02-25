$(document).on('click', '.tmp-unavailable, #add_column, #close-request, #info, .download-empl-cv, #add_ancete', (event) ->
  event.preventDefault()
  toastr.info('Функционал временно недоступен')
)
