price = <%= @position.price_group.customer_price %>
quantity = $('#num_of_employees').find('input').val()
total = quantity * price
$('#order_position_id').val('<%= @position.id %>')
$('#position_title').html('<%= @position.title %>')
$('#num_of_employees').data('price', price)
$('#price').html(price)
$('#total').html(total)