<% complaint = render partial: 'admin/proposal_employees/complaints/complaint', locals: { complaint: @complaint } %>
id = <%= @complaint.id %>
$('#complaint_' + id).replaceWith("<%= j complaint %>")
