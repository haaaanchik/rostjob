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

$(document).on('change', '#order_number_of_employees', (event) ->
  price = $(this).parent().data('price')
  quantity = $(this).val()
  total = quantity * price
  $('#price').html(price)
  $('#total').html(total)
)

$(document).on('click', '[data-order-position="new"]', (event) ->
  val = $('#order_position_search').val()

  if val == ''
    toastr.info('Введите название профессии')
  else
    data = position: {title: val, duties: '', price_group_id: 1}
    $.ajax
      method: 'post'
      url: '/profile/orders/add_position'
      data: data
    return
)

@apply_position = (item) ->
  price = item.price
  quantity = $('#num_of_employees').find('input').val()
  total = quantity * price
  $('#order_position_id').val(item.id)
  $('#position_title').html(item.label)
  $('#num_of_employees').data('price', price)
  $('#price').html(price)
  $('#total').html(total)
#  content = tinymce.get('order_description').getContent()
#  if item.duties == null
#    duties = ' '
#  else
#    duties = item.duties
#  html = "#<p><strong>Должностные обязанности:</strong><br />#{duties}</p>"
#  tinymce.get('order_description').setContent(html + content)
