<% if @employee_cv_id %>
<% my_orders_modal = render partial: 'index.html.slim' %>
normal_modal_open('formModalMyOrders', "<%= j my_orders_modal %>")
<% else %>
<% orders = render partial: 'index_with_search.html.slim' %>
$('#right_window').html("<%= j orders %>")
<% end %>
