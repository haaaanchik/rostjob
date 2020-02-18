$(document).on('click', '.tmp-unavailable, #add_column, #info, .download-empl-cv, #add_ancete', (event) ->
  event.preventDefault()
  toastr.info('Функционал временно недоступен')
)
