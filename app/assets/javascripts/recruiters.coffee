$ ->
  $('.star-rating').raty({readOnly: true})

  $('#generalRecruiterModal').on('show.bs.modal', (event) ->
    modal = $(this)
    recruiter_row = $(event.relatedTarget)
    recruiter_id = recruiter_row.data('recruiter_id')
    url = recruiter_row.data('url')
    success = (data, status, xhr) ->
      console.log data, modal
      modal.find('.modal-body').empty().append(data)
    recruiter = ajax_client(url,null,success)
    modal.find('.modal-title').text('Анкета рекрутера № ' + recruiter_id)
  )
