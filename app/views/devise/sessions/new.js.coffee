$("#modal_container").html "<%= escape_javascript(render partial: 'devise/sessions/login') %>"
$('#LogIn').modal()