<% if @status == 'success' %>
toastr.success('Данные успешно сохранены')
normal_modal_close('formModalEditWithdrawalMethod')
$("#withdrawal_method_id_<%= @withdrawal_method.id %>").data('valid', 'true')
<% else %>
toastr.error('<%= j @text %>', 'Неудача!')
<% end %>
