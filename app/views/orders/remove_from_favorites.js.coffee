$('#favorite_id_<%= @order.id %>').remove()
toastr.info('Исключено из избранного', 'Успех!')
