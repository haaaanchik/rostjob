<% if params[:favorable_id] %>
$('#req_order_<%= @order.id %>').remove()
toastr.info('Исключено из избранного', 'Успех!')
<% else %>
<% rdr = render partial: 'orders/order', object: @order %>

$('#req_order_<%= @order.id %>').replaceWith('<%= j rdr %>');
<% text = params[:tag] == 'star' ? 'Добавлено в избранное' : 'Исключено из избранного' %>
toastr.info('<%= text %>', 'Успех!')
<% end %>