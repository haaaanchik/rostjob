$(document).on('show.bs.modal', '#fireCandidateModal', (event) ->
  button = $(event.relatedTarget)
  name = button.data('name')
  gender = button.data('gender')
  birthdate = button.data('birthdate')
  id = button.data('id')
  proposal_id = button.data('proposal-id')
  modal = $(this)
  modal.find('.name').text('Имя: ' + name)
  modal.find('.gender').text('Пол: ' + gender)
  modal.find('.birthdate').text('Дата рождения: ' + birthdate)
  modal.find('#candidate_id').val(id)
  modal.find('#candidate_proposal_id').val(proposal_id)
)

$(document).on('ajax:success', '.candidates-menu-button', (event) ->
  $('.candidates-menu-button').removeClass('active')
  result = event.detail[2].response
  $('#order_candidates').html(result)
  $(this).addClass('active')
)
