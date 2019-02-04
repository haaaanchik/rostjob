<% orders = render partial: 'index.html.slim' %>
$('#orders_search_result').html("<%= j orders %>")
