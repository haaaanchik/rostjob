class OrderTemplates
  reloadPage = 0

  @init: ->
    @tabsActive()
    @bind()

  @tabsActive: ->
    if reloadPage == 1
      $('.header .item-type.js-input-type[data-target="published"]').removeClass('active')
      $('.orders-list .order-list__body[data-tab="published"]').removeClass('show-tab')
      $('.header .item-type.js-input-type[data-target="templates"]').addClass('active')
      $('.orders-list .order-list__body[data-tab="templates"]').addClass('show-tab')
      reloadPage = 0

  @bind: ->
    $('#order_template_position_search').on 'focusin', @addProfessionAutocomplete
    $('#delete').on 'click', @destroyArray
    $('#copy').on 'click', @copyCollection
    $('#save_as_template').on 'click', @showNameInput
    $('.order-template__name').on 'focusout', @saveName

  @destroyArray: ->
    if confirm('Вы действительно хотите удалить выбранные шаблоны?')
      ajaxSendCopyOrDelete('/order_templates/destroy_array', 'DELETE')

  @copyCollection: ->
    if confirm('Вы действительно хотите копировать выбранные шаблоны?')
      ajaxSendCopyOrDelete('/order_templates/copy', 'POST')

  ajaxSendCopyOrDelete = (url, method) ->
    order_template_ids = []
    production_sites = $('.orders-list[data-production_sites-id]').data('production_sites-id')
    $('.order > input:checked').each (index, element) ->
      order_template_id = element.value
      order_template_ids.push order_template_id

    $.ajax
      url: '/profile/production_sites/' + production_sites + url
      method: method
      dataType: 'json'
      data:
        order_template_ids: order_template_ids
      success: ->
        reloadPage = 1
        Turbolinks.visit(window.location.href)
    return

  @addProfessionAutocomplete: ->
    $this = $(this)
    autocomplete = $this.autocomplete(
      source: $this.data('auto-url')
      focus: _doFocusStuff
    )

    autocomplete_handle = autocomplete.data('ui-autocomplete')
    autocomplete_handle._renderMenu = _renderMenu
    autocomplete_handle._renderItemData = _renderItemData
    autocomplete_handle._renderItem = _renderItem

  _renderMenu = (ul, items) ->
    $self = this;
    $t = $('<table>').appendTo(ul)
    $t.append($('<thead>'))
    $t.find('thead').append($('<tr>'))
    $row = $t.find('tr')
    $('<th>').html('Профессия').appendTo($row)
    $('<th>').html('Цена').appendTo($row)
    $('<tbody>').appendTo($t);
    $.each items, (index, item) ->
      $self._renderItemData(ul, $t.find('tbody'), item)

  _renderItemData = (ul, table, item) ->
    return this._renderItem(table, item).data('ui-autocomplete-item', item)

  _renderItem = (table, item) ->
    $row = $('<tr>', { class: 'ui-menu-item', role: 'presentation' })
    $('<td>').html(item.label).appendTo($row)
    $('<td>').html(item.price).appendTo($row)
    return $row.appendTo(table)

  _doFocusStuff = (event, ui) ->
    if ui.item
      $item = ui.item
      $('#order_template_position_search').val($item.label)
      $('#profession_price').val($item.price)
      $('#order_template_position_id').val($item.id)
    return false

  @showNameInput: ->
    $(this).fadeOut 700
    $(this).next().fadeIn 700, ->
      $(this).removeClass('d-none')

  @saveName: ->
    productionSiteId = $('.pattern_body_steps_form').data('production-site-id')
    orderTemplateId = $(this).data('id')
    url = '/profile/production_sites/' + productionSiteId + '/order_templates/' + orderTemplateId + '/save_name'
    $.ajax
      url: url
      method: 'put'
      dataType: 'json'
      data:
        name: $(this).val()
      success: (data) ->
        $('#order_template_template_saved').val(true)
        $('#template_name').remove()
        $('#save_as_template').parent().append('<i class="ml-4 green-text fa fa-check"> <span class="ml-2">шаблон успешно сохранен</span> </i>')
      error: (msg) ->
        console.log(msg)
        toastr.error('Не удалось сохранить шаблон')
    return

$(document).on 'turbolinks:load', ->
  OrderTemplates.init()

$(document).on('change', '[id=order_template_filter_for_cis]', ->
  form = document.getElementById('order_template_search')
  form.submit()
)

$(document).on('show.bs.modal', '#formModalNewOrderTemplate', ->
  $('input[type=tel]').inputmask("+7(999)-999-99-99")
)

$(document).on('click', '[id^=order_template_number_of_employees_step_down]', (event) ->
  element = $(this)
  order_template_id = element.data('order-template-id')
  number_of_employees_id = 'order_template_number_of_employees_' + order_template_id
  number_of_employees_element = $("##{number_of_employees_id}")
  customer_price = number_of_employees_element.data('customer-price')
  number_of_employees_element[0].stepDown()
  number_of_employees = number_of_employees_element.val()
  customer_total = customer_price * number_of_employees
  customer_total_class = '.customer-total-' + order_template_id
  $(customer_total_class).html(customer_total)
)

$(document).on('click', '[id^=order_template_number_of_employees_step_up]', (event) ->
  element = $(this)
  order_template_id = element.data('order-template-id')
  number_of_employees_id = 'order_template_number_of_employees_' + order_template_id
  number_of_employees_element = $("##{number_of_employees_id}")
  customer_price = number_of_employees_element.data('customer-price')
  number_of_employees_element[0].stepUp()
  number_of_employees = number_of_employees_element.val()
  customer_total = customer_price * number_of_employees
  customer_total_class = '.customer-total-' + order_template_id
  $(customer_total_class).html(customer_total)
)

$(document).on('show.bs.modal', '#formModalNewOrderTemplate', ->
  tinymce.init({
    selector: 'textarea.tinymce'
    branding: false
    language: 'ru_RU'
    elementpath: false
    statusbar: false
    menubar: false
    toolbar: 'undo redo | bold italic underline | indent outdent | numlist bullist'
    plugins: "lists"
    forced_root_block: false
  })
)

$(document).on('hide.bs.modal', '#formModalNewOrderTemplate', ->
  tinymce.remove('textarea.tinymce')
)
