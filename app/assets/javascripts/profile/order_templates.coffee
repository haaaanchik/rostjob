# $(document).on('change', '.order-template-number-of-employees-short', (event) ->
#   element = $(this)
#   order_template_id = element.data('order-template-id')
#   customer_price = element.data('customer-price')
#   number_of_employees = element.val()
#   customer_total = customer_price * number_of_employees
#   customer_total_class = '.customer-total-' + order_template_id
#   console.log order_template_id, customer_price, number_of_employees, customer_total, customer_total_class
#   $(customer_total_class).html(customer_total)
# )

$(document).on('show.bs.modal', '#formModalNewOrderTemplate', ->
  $('input[type=tel]').inputmask("+7(999)-999-99-99")
)

$(document).on('click', '[id^=order_template_number_of_employees_step_down]', (event) ->
  element = $(this)
  order_template_id = element.data('order-template-id')
  number_of_employees_id = 'order_template_number_of_employees_' + order_template_id
  number_of_employees_element = $("##{number_of_employees_id}")
  customer_price = number_of_employees_element.data('customer-price')
  number_of_employees_element[0].stepDown()
  number_of_employees = number_of_employees_element.val()
  customer_total = customer_price * number_of_employees
  customer_total_class = '.customer-total-' + order_template_id
  $(customer_total_class).html(customer_total)
)

$(document).on('click', '[id^=order_template_number_of_employees_step_up]', (event) ->
  element = $(this)
  order_template_id = element.data('order-template-id')
  number_of_employees_id = 'order_template_number_of_employees_' + order_template_id
  number_of_employees_element = $("##{number_of_employees_id}")
  customer_price = number_of_employees_element.data('customer-price')
  number_of_employees_element[0].stepUp()
  number_of_employees = number_of_employees_element.val()
  customer_total = customer_price * number_of_employees
  customer_total_class = '.customer-total-' + order_template_id
  $(customer_total_class).html(customer_total)
)

$(document).on('show.bs.modal', '#formModalNewOrderTemplate', ->
  tinymce.init({
    selector: 'textarea.tinymce'
    branding: false
    language: 'ru_RU'
    elementpath: false
    statusbar: false
    menubar: false
    toolbar: 'undo redo | bold italic underline | indent outdent | numlist bullist'
    plugins: "lists"
    forced_root_block: false
  })
)

$(document).on('hide.bs.modal', '#formModalNewOrderTemplate', ->
  tinymce.remove('textarea.tinymce')
)
