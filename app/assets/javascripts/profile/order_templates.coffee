$('#order_template_number_of_employees').on('change', (event) ->
  element = $(this)
  console.log element
  order_template_id = element.data('order-template-id')
  customer_price = element.data('customer-price')
  number_of_employees = element.val()
  customer_total = customer_price * number_of_employees
  customer_total_class = '.customer-total-' + order_template_id
  console.log order_template_id, customer_price, number_of_employees, customer_total, customer_total_class
  $(customer_total_class).html(customer_total)
)
