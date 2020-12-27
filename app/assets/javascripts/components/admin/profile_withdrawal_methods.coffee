class RostJob.ProfileBalancesWithdrawalMethods
  @init: ->
    @bind()

  @bind: ->
    $("button[type='submit']").on 'click', @submitForm

  @submitForm: (e) ->
    $selected = $("[name='withdrawal_method_id']:checked")
    valid = $selected.data('valid')

    if !valid
      $selected.parents('tr').find('.action-link')[0].click()
      toastr.info('Вам следует заполнить данные', 'Внимание!')
      e.preventDefault()