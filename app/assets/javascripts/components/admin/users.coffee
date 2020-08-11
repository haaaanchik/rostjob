class RostJob.AdminUsersIndex
  @init: ->
    @bind()

  @bind: ->
    $('[id^=manager_]').on 'change', @changeStatusFreeManager

  @changeStatusFreeManager: (e) ->
    element = $(e.target)
    userId = element.data('user-id')
    checked = element.prop('checked')

    $.ajax
      url: 'users/'+userId+'/change_manager_status'
      method: 'PUT'
      dataType: 'script'
      data:
        active: checked
      success: ->
        toastr.success('Данные успешно обновлены!')
      error: ->
        toastr.error('Ошибка! Не удалось выполнить действие')

