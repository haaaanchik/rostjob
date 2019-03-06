<% rdr = render partial: 'orders/order', object: @order, locals: { order_id: 'order_id_' } %>
$('#order_id_<%= @order.id %>').replaceWith('<%= j rdr %>')
$('#favorite_id_<%= @order.id %>').remove()
toastr.info('Исключено из избранного', 'Успех!')
