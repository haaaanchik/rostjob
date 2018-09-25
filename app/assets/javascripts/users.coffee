$ ->
  $('.clients').on('click', (event) ->
    element = event.target
    value = element.childNodes[0].value
    company_name = $('#user_profile_company_name')[0]
    company_block = $('#user_profile_company_name')[0].parentElement
    if value == 'employee' || value == 'recruiter'
      $(company_name).prop('disabled', true)
      $(company_block).hide()
    else
      $(company_name).prop('disabled', false)
      $(company_block).show()
  )

  $('.registration-form').on('ajax:success', (event) ->
    errors = event.detail[0]
    form = $(this)
    if errors['full_name']
      $('.full-name', form).html(errors['full_name'][0])
      $('#user_full_name', form).addClass('is-invalid')
    if errors['email']
      $('.email', form).html(errors['email'][0])
      $('#user_email', form).addClass('is-invalid')
    if errors['password']
      $('.password', form).html(errors['password'][0])
      $('#user_password', form).addClass('is-invalid')
  )

  $(document).on('focusin', '.is-invalid', (event) ->
    $(event.currentTarget).removeClass('is-invalid')
  )
