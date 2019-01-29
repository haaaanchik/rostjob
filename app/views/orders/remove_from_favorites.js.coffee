$('#req_order_<%= @order.id %>').remove()
toastr.info('Исключено из избранного', 'Успех!')
