<% if @status == 'success' %>
toastr.success('Данные успешно сохранены')
normal_modal_close('formModalEditWithdrawalMethod')
<% else %>
toastr.error('<%= j @text %>', 'Неудача!')
<% end %>
