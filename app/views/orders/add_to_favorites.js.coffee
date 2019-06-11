<% rdr = render partial: 'orders/order', object: @order %>

$('#order_id_<%= @order.id %>').replaceWith('<%= j rdr %>')
<% text = 'Добавлено в избранное' %>
toastr.info('<%= text %>', 'Успех!')
