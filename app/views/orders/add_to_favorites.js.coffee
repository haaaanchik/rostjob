<% rdr = render partial: 'orders/order', object: @order, locals: { order_id: 'order_id_' } %>

$('#order_id_<%= @order.id %>').replaceWith('<%= j rdr %>')
<% text = 'Добавлено в избранное' %>
toastr.info('<%= text %>', 'Успех!')
