<% if current_profile.customer? %>
  <% rdr = render partial: 'orders/order', object: @order, locals: { order_id: 'order_id_' } %>
<% else %>
  <% rdr = render partial: 'orders/contractor_order', object: @order, locals: { order: @order } %>
<% end %>

$('#order_id_<%= @order.id %>').replaceWith('<%= j rdr %>')
<% text = 'Добавлено в избранное' %>
toastr.info('<%= text %>', 'Успех!')
