<% rdr = render partial: 'profile/employee_cvs/employee_cv',
 object: @employee_cv %>
$('#candidates_list').prepend('<%= j rdr %>')