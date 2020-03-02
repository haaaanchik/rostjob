$(document).on('click', '.tmp-unavailable, #add_column, #info, .download-empl-cv', (event) ->
  event.preventDefault()
  toastr.info('Функционал временно недоступен')
)
