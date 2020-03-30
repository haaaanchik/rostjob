$(document).on('click', '.tmp-unavailable, #add_column, #info, .download-empl-cv, #ticket-attach-file, .favorite-info, .favorite-remove', (event) ->
  event.preventDefault()
  toastr.info('Функционал временно недоступен')
)
