$ ->
  $('.star-rating').raty(
    readOnly: true
    starHalf: image_path('star-half.png')
    starOff: image_path('star-off.png')
    starOn: image_path('star-on.png')
  )

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
  $('#generalRecruiterModal').on('hide.bs.modal', (event) ->
    modal = $(this)
    modal.find('.modal-body').empty()
    modal.find('.modal-title').empty()
  )
