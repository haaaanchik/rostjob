class Orders
  @init: ->
    @tabsActive()
    @clickProposalEmployee()
    @bind()

  @tabsActive: ->
    states = ['templates', 'pending_payments', 'on_moderation', 'published', 'finished']
    active = $('.header.active-tab').data('active')
    if states.includes(active)
      $('.header .item-type.js-input-type[data-target="published"]').removeClass('active')
      $('.orders-list .order-list__body[data-tab="published"]').removeClass('show-tab')
      $('.header .item-type.js-input-type[data-target="'+ active + '"]').addClass('active')
      $('.orders-list .order-list__body[data-tab="'+ active + '"]').addClass('show-tab')

  @clickProposalEmployee: ->
    if $('#click_proposal_employee').length
      $('#click_proposal_employee')[0].click()

  @bind: ->
    $('#order_publish').on 'click', @publish

  @publish: ->
    $form = $(this).parent().prev().find('form.edit_order')
    $form.submit()

$(document).on 'turbolinks:load', ->
  Orders.init()

$ ->
  $('label[for=order_accepted]').on('click', (event) ->
    element = $('#order_accepted')
    checked = element.prop('checked')
    if checked == false
      $('.order-submit-button').removeClass('disabled')
    else
      $('.order-submit-button').addClass('disabled')
  )

  $('#executorModal').on('show.bs.modal', (event) ->
    target = $(event.relatedTarget)
    order_id = target.data('order_id')
    proposal_id = target.data('proposal_id')
    recruiter_id = target.data('recruiter_id')
    modal = $(this)
# modal.find('.modal-title').text('New message to ' + profile_id)
# modal.find('.modal-title').text('New message to ' + recipient)
# modal.find('.modal-body input').val(recipient)
  )

$('#order_form').on('submit', (event) ->
  event_source = $(event.originalEvent.explicitOriginalTarget)
  type = event_source.attr('type')
  if type != 'submit'
    return false
)


$(document).on('mouseenter', 'table.collapsable, .clickable-order-row, .clickable-pe, .clickable-employee-cv', (event) ->
  $(this).css('cursor', 'pointer')
)

$(document).on('mouseenter', '.collapse_hide', (event) ->
  $(this).css('cursor', 'pointer')
)

$(document).on('click', 'table.collapsable', (event) ->
  order_id = $(this).data('order-id')
  collapse_selector = '.collapse[data-order-id=' + order_id + ']'
  $(this).fadeOut(400, ->
    $(collapse_selector).fadeIn(400)
  )
)

$(document).on('click', '.collapse_hide', (event) ->
  order_id = $(this).data('order-id')
  row_selector = 'table.collapsable[data-order-id=' + order_id + ']'
  collapse_selector = '.collapse[data-order-id=' + order_id + ']'
  $(collapse_selector).fadeOut(400, ->
    $(row_selector).fadeIn(400)
  )
)

$(document).on('click', '#show_all', (event) ->
  $('#hide_all').removeClass('active')
  $(this).addClass('active')
  row_selector = 'table.collapsable'
  collapse_selector = '.collapsable_card'
  $(row_selector).fadeOut(400, ->
    $(collapse_selector).fadeIn(400)
  )
)

$(document).on('click', '#hide_all', (event) ->
  $('#show_all').removeClass('active')
  $(this).addClass('active')
  row_selector = 'table.collapsable'
  collapse_selector = '.collapsable_card'
  $(collapse_selector).fadeOut(400, ->
    $(row_selector).fadeIn(400)
  )
)

$(document).on('change', '#order_template_number_of_employees', (event) ->
  price = $(this).parent().data('price')
  customer_price = $('#position_table').data('customer-price')
  contractor_price = $('#position_table').data('contractor-price')
  quantity = $(this).val()
  customer_total = quantity * customer_price
  contractor_total = quantity * contractor_price
  $('#customer_price').html(customer_price)
  $('#customer_total').html(customer_total)
  $('#order_template_contractor_price').val(contractor_price)
  $('#contractor_total').html(contractor_total)
)

$(document).on('change', '#order_number_of_employees', (event) ->
  price = $(this).parent().data('price')
  customer_price = $('#position_table').data('customer-price')
  contractor_price = $('#position_table').data('contractor-price')
  quantity = $(this).val()
  customer_total = quantity * customer_price
  contractor_total = quantity * contractor_price
  $('#customer_price').html(customer_price)
  $('#customer_total').html(customer_total)
  $('#order_contractor_price').val(contractor_price)
  $('#contractor_total').html(contractor_total)
)

$(document).on('change', '#order_template_contractor_price', (event) ->
  base_customer_price = $('#position_table').data('base-customer-price')
  base_contractor_price = $('#position_table').data('base-contractor-price')
  quantity = $('#order_template_number_of_employees').val()
  contractor_price = $(this).val()
  customer_price = base_customer_price
  console.log base_customer_price, base_contractor_price, quantity, contractor_price

  if contractor_price != base_contractor_price
    factor = contractor_price / base_contractor_price
    customer_price = Math.ceil(base_customer_price * factor)
    console.log factor, customer_price


  $('#position_table').data('customer-price', customer_price)
  $('#position_table').data('contractor-price', contractor_price)

  customer_total = quantity * customer_price
  contractor_total = quantity * contractor_price
  $('#customer_price').html(customer_price)
  $('#customer_total').html(customer_total)
  $('#order_template_contractor_price').val(contractor_price)
  $('#contractor_total').html(contractor_total)
)

$(document).on('change', '#order_contractor_price', (event) ->
  base_customer_price = $('#position_table').data('base-customer-price')
  base_contractor_price = $('#position_table').data('base-contractor-price')
  quantity = $('#order_number_of_employees').val()
  contractor_price = $(this).val()
  customer_price = base_customer_price
  console.log base_customer_price, base_contractor_price, quantity, contractor_price

  if contractor_price != base_contractor_price
    factor = contractor_price / base_contractor_price
    customer_price = Math.ceil(base_customer_price * factor)
    console.log factor, customer_price


  $('#position_table').data('customer-price', customer_price)
  $('#position_table').data('contractor-price', contractor_price)

  customer_total = quantity * customer_price
  contractor_total = quantity * contractor_price
  $('#customer_price').html(customer_price)
  $('#customer_total').html(customer_total)
  $('#order_contractor_price').val(contractor_price)
  $('#contractor_total').html(contractor_total)
)

# FIXME: refactor this asap
@apply_position2 = (item) ->
  customer_price = item.price
  contractor_price = item.contractor_price
  quantity = $('#order_template_number_of_employees').val()
  customer_total = quantity * customer_price
  contractor_total = quantity * contractor_price
  $('#order_template_position_id').val(item.id)
  $('#position_title').html(item.label)
  $('#position_table').data('customer-price', customer_price)
  $('#position_table').data('contractor-price', contractor_price)
  $('#position_table').data('base-customer-price', customer_price)
  $('#position_table').data('base-contractor-price', contractor_price)
  $('#customer_price').html(customer_price)
  $('#customer_total').html(customer_total)
  $('#order_template_contractor_price').val(contractor_price)
  $('#order_template_contractor_price').prop('disabled', false)
  $('#order_template_number_of_employees').prop('disabled', false)
  $('#contractor_total').html(contractor_total)

@apply_position = (item) ->
  customer_price = item.price
  contractor_price = item.contractor_price
  quantity = $('#order_number_of_employees').val()
  customer_total = quantity * customer_price
  contractor_total = quantity * contractor_price
  $('#order_position_id').val(item.id)
  $('#position_title').html(item.label)
  $('#position_table').data('customer-price', customer_price)
  $('#position_table').data('contractor-price', contractor_price)
  $('#position_table').data('base-customer-price', customer_price)
  $('#position_table').data('base-contractor-price', contractor_price)
  $('#customer_price').html(customer_price)
  $('#customer_total').html(customer_total)
  $('#order_contractor_price').val(contractor_price)
  $('#order_contractor_price').prop('disabled', false)
  $('#order_number_of_employees').prop('disabled', false)
  $('#contractor_total').html(contractor_total)

$(document).on('change', '[id=order_filter_for_cis]', ->
  form = document.getElementById('order_search')
  form.submit()
)

$(document).on('click', '.clickable-order-row, .clickable-pe', (event) ->
  window.location = $(event.currentTarget).data('href')
)

$(document).on('click', '.reserve-block', ->
  $(this).children().last().toggleClass('fa-chevron-up fa-chevron-down')
  $('.reserve-items').fadeToggle(500)
)

$(document).on('click', '[id^=order_number_of_employees_step_down]', (event) ->
  numberOfEmployeesElement = $('#order_number_of_employees')
  customerPrice = numberOfEmployeesElement.data('customer-price')
  numberOfEmployeesElement[0].stepDown()
  numberOfEmployees = numberOfEmployeesElement.val()
  customerTotal = parseFloat(customerPrice * numberOfEmployees)
  $('#customer-total').html(customerTotal)
)

$(document).on('click', '[id^=order_number_of_employees_step_up]', (event) ->
  numberOfEmployeesElement = $('#order_number_of_employees')
  customerPrice = numberOfEmployeesElement.data('customer-price')
  numberOfEmployeesElement[0].stepUp()
  numberOfEmployees = numberOfEmployeesElement.val()
  customerTotal = parseFloat(customerPrice * numberOfEmployees)
  console.log(customerTotal)
  $('#customer-total').html(customerTotal)
)
