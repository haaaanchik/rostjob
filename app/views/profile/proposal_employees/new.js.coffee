<% partial_form = render partial: 'profile/proposal_employees/form' %>
<% over_partial = render_escape 'layouts/modal_options',
 {modal_title: 'Отправка новой анкеты', modal_name: 'NewProposalEmployee', local_render: partial_form } %>
normal_modal_open 'formModalNewProposalEmployee', "<%= over_partial %>"
