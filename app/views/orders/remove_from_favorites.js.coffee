<% rdr = render partial: 'orders/order', object: @order %>
$('#order_id_<%= @order.id %>').replaceWith('<%= j rdr %>')
toastr.info('Исключено из избранного', 'Успех!')
