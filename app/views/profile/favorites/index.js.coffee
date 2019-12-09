<% if @employee_cv_id %>
<% my_orders_modal = render partial: 'index.html.slim' %>
$("#employee_cv_modal_<%= @employee_cv_id %>").modal('hide')
normal_modal_open('formModalMyOrders', "<%= j my_orders_modal %>")
<% else %>
<% orders = render partial: 'index_with_search.html.slim' %>
$('#main_row').html("<%= j orders %>")
<% end %>
$('[data-toggle="popover"]').popover()
