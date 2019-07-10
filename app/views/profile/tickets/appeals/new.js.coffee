<% partial_form = render partial: 'form' %>
<% over_partial = render_escape 'layouts/modal_options', {modal_title: 'Новое обращение', modal_name: 'NewAppeal', local_render: partial_form } %>
normal_modal_open('formModalNewAppeal', "<%= over_partial %>")
