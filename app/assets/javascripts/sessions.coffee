$ ->
  $('.login-form').on('ajax:success', (event) ->
    errors = event.detail[0]
    $('.login').html(errors['email'])
    $('#email').addClass('is-invalid') if errors['email']
    $('.password').html(errors['password'])
    $('#password').addClass('is-invalid') if errors['password']
  )
