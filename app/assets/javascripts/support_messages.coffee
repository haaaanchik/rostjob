$ ->
  $(document).on('ajax:success', '.contact-form', (event) ->
    data = event.detail[0]
    if data.hasOwnProperty('errors')
      errors = data['errors']
      error_messages = Object.keys(errors).map((key) ->
        return key + ': ' + errors[key]
      )

      toastr['error'](error_messages.join("<br>"))
      grecaptcha.reset()
  )
