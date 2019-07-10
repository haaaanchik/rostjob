<% partial_form = render partial: 'form', locals: { incident: @new_incident } %>
<% over_partial = render_escape 'layouts/modal_options', { modal_title: 'Новый спор', modal_name: 'NewIncident', local_render: partial_form } %>
normal_modal_open('formModalNewIncident', "<%= over_partial %>")
