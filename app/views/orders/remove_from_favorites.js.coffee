crmFavorite = $('.card-list[data-order-id=<%= @order&.id %>]')

if crmFavorite.length
  $(crmFavorite).slideUp('slow');
  toastr.success('Заявка успешно удалена из избранных.')
else
  $('#favorite_id_<%= @order.id %>').remove()
  <% if current_profile.customer? %>
    <% rdr = render partial: 'orders/order', object: @order, locals: { order_id: 'order_id_' } %>
  <% else %>
    <% rdr = render partial: 'orders/contractor_order', object: @order, locals: { order: @order } %>
  <% end %>
  $('#order_id_<%= @order.id %>').replaceWith('<%= j rdr %>')
  toastr.info('Исключено из избранного', 'Успех!')
