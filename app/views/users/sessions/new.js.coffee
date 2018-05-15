$("#modal_container").html "<%= escape_javascript(render partial: 'users/sessions/login') %>"
$('#LogIn').modal()