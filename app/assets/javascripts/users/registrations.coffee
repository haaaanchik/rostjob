  $(document).on('click', 'label[for=user_terms_of_service]', (event) ->
    element = $('#user_terms_of_service')
    checked = element.prop('checked')
    if checked == false
      $('[name=customer], [name=contractor]').removeClass('disabled')
    else
      $('[name=customer], [name=contractor]').addClass('disabled')
  )

