<% if @employee_cv_id %>
<% orders = render partial: 'index.html.slim' %>
$('#orders_search_result').html("<%= j orders %>")
<% else %>
<% orders = render partial: 'index_with_search.html.slim' %>
$('#right_window').html("<%= j orders %>")
<% end %>
$('[data-toggle="popover"]').popover()
