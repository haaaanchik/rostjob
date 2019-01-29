<% rdr = render partial: 'orders/order', object: @order %>

$('#req_order_<%= @order.id %>').replaceWith('<%= j rdr %>');
<% text = 'Добавлено в избранное' %>
toastr.info('<%= text %>', 'Успех!')
