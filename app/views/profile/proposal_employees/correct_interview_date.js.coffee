<% if @result_success %>
$('#correct_interview_date_submit').addClass('disabled');
toastr.success('Изменения сохранены!')
<% else %>
toastr.error('Ошибка!')
<% end %>