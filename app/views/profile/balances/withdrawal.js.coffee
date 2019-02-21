<% if @status == 'success' %>
toastr.success('Средства успешно поставлены в очередь на вывод')
window.location.replace('<%= profile_balance_path %>')
<% else %>
toastr.error('<%= j @text %>', 'Неудача!')
<% end %>
