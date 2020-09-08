#= require components/preview_image

class RostJob.UsersRegistrationsEdit
  
  @init: ->
    RostJob.PreviewImage.init()
    @bind()

  @bind: ->
    $('#setting-page').on 'click', '#show_password_block', @showPasswordBlock

  @showPasswordBlock: (e) ->
    e.preventDefault()
    position = $(this)
    $('#password_block').toggleClass('d-none')
    if $('#password_block').is(':visible')
      position.text('Скрыть')
    else
      position.text('Ввести пароль')
      $('#user_password, #user_password_confirmation, #user_current_password').val('')
