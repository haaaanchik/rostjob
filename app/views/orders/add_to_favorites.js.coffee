<% rdr = render partial: 'orders/order', object: @order, locals: { order_id: 'order_id_' } %>

$('#order_id_<%= @order.id %>').replaceWith('<%= j rdr %>')
order_id = <%= @order.id %>
table_selector = '.collapsable[data-order-id=' + order_id + ']'
collapse_selector = '.collapse[data-order-id=' + order_id + ']'
$(table_selector).fadeOut(400, ->
  $(collapse_selector).fadeIn(400)
)
<% text = 'Добавлено в избранное' %>
toastr.info('<%= text %>', 'Успех!')
