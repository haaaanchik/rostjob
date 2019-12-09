normal_modal_close 'formModalNewEmployeeCv'
<% partial_form = render partial: 'profile/employee_cvs/form_full', locals: { url: profile_employee_cvs_path, mth: :post} %>
$('#main_row').html('<%= partial_form %>')
