<% rdr = render partial: 'profile/employee_cvs/proposed',
 object: @employee_pr, as: :proposed %>
$('#candidates_list').prepend('<%= j rdr %>')