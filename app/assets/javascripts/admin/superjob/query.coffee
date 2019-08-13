$(document).on('change', '[id^=super_job_query_active_]', (event) ->
  element = $(event.target)
  activate_url = element.data('activate-url')
  deactivate_url = element.data('deactivate-url')
  url = ''
  checked = element.prop('checked')

  if checked == true
    url = activate_url
  else
    url = deactivate_url

  $.ajax({
    url: url
    method: 'PUT'
    indexValue: { checked: checked },
    success: success,
    error: error
  })
)

success = ->
  if this.indexValue.checked == true
    toastr.success('Запрос успешно включен в список исполнения')
  else
    toastr.success('Запрос успешно исключен из списка исполнения')

error = ->
  toastr.error('Ошибка! Не удалось выполнить действие с запросом')

$(document).on('change', '[id^=super_job_query_activeall]', (event) ->
  element = $(event.target)
  activate_url = element.data('activate-url')
  deactivate_url = element.data('deactivate-url')
  url = ''
  checked = element.prop('checked')

  if checked == true
    url = activate_url
  else
    url = deactivate_url

  $.ajax({
    url: url
    method: 'PUT'
    indexValue: { checked: checked },
    success: success_all,
    error: error_all
  })
)

success_all = ->
  if this.indexValue.checked == true
    $('[id^=super_job_query_active_]').prop('checked', true)
    toastr.success('Все запросы успешно включены в список исполнения')
  else
    $('[id^=super_job_query_active_]').prop('checked', false)
    toastr.success('Все запросы успешно исключены из списка исполнения')

error_all = ->
  toastr.error('Ошибка! Не удалось выполнить действие с запросами')

