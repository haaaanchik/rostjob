class RostJob.ProfileInvoicesIndex

  @init: ->
    @bind()

  @bind: ->
    $('.remove_invoice').on 'ajax:success', @removeInvoice
    $('.remove_invoice').on 'ajax:errors', @errorsRemoveInvoice

  @removeInvoice: ->
    $(this).parents('tr').fadeOut 'slow', ->
      $(this).remove()

  @errorsRemoveInvoice: ->
    toastr.warning('Не удалось удалить счёт, обратитесь к администрации сайта')
