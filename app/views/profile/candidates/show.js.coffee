<% over_partial = render_escape 'modal_candidate', { candidate: @candidate } %>
normal_modal_open('candidate-show', "<%= over_partial %>")
