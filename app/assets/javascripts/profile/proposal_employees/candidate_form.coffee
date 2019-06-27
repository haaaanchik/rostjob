$(document).on('click', '.correct-interview-date', ->
  if($(this).find('input.disabled').length != 0)
    toastr.info('Выберите другую дату собеседования')
)
