class RostJob.ProfileProductionSitesOrdersIndex
  @init: ->
    @bind()

  @bind: ->
    $('.company-page__tabs').on 'click', 'input#check_all[type=checkbox]', @clickCheckboxes
    $('.delete_button').on 'click', @destroyArray
    $('.copy_button').on 'click', @copyCollection
  
  @clickCheckboxes: ->
    $('.order-list__body.show-tab input:checkbox').not(this).click()

  @destroyArray: ->
    if $('.order-list__body.show-tab .order > input:checked').length == 0
      toastr.error('Вам следует отметить заявку прежде чем удалять')
      return

    if confirm('Вы действительно хотите удалить выбранные шаблоны?')
      openTabs = $('.js-input-type.active').data('target')
      url = if openTabs == 'templates'
              '/order_templates/destroy_array'
            else
              '/orders'

      ajaxSendCopyOrDelete(url, 'DELETE')
  
  @copyCollection: ->
    if $('.order > input:checked').length == 0
      toastr.error('Вам следует отметить заявку прежде чем копировать')
      return

    if confirm('Вы действительно хотите копировать выбранные шаблоны?')
      ajaxSendCopyOrDelete('/order_templates/copy', 'POST')

  ajaxSendCopyOrDelete = (url, method) ->
    order_ids = []
    production_sites = $('.orders-list[data-production_sites-id]').data('production_sites-id')
    $('.show-tab .order > input:checked').each (index, element) ->
      order_id = element.value
      order_ids.push order_id

    $.ajax
      url: '/profile/production_sites/' + production_sites + url
      method: method
      dataType: 'json'
      data:
        order_ids: order_ids
      success: ->
        actionAfterCopyOrDelete(order_ids, method)
        notifyAfterCopyOrDelete(method)
    return

  notifyAfterCopyOrDelete = (method) ->
    text = 'Заявка(и) успешно '

    if method == 'DELETE'
      text += 'удалены'
    else
      text += 'скопированны'
  
    toastr.success(text)

  actionAfterCopyOrDelete = (ids, method) ->
    if method == 'DELETE'
      jQuery.each ids, (index, element) ->
        $(".order-list__body.show-tab .order[data-order-id='"+element+"']").fadeOut 'slow', ->
          $(this).remove()
    else
      reloadPage = 1
      url = window.location.href.split('?')[0]+'?tab_state='+$('.js-input-type.active').data('target')
      Turbolinks.visit(url)