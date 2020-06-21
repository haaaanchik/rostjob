class SettingsPage
  @init: ->
    @bind()
    @toggleActiveSettingsPage()

  @bind: ->
    $('.burger').on 'click', @openAndCloseMobileMenu
#    $("a.active-link").on 'click', @toggleActiveSettingsPage
    $('#setting-page').on 'click', '#show_password_block', @showPasswordBlock

  @openAndCloseMobileMenu: ->
    burgerLines = $('.burger span')
    burgerLines[0].classList.toggle('rotate-right')
    burgerLines[1].classList.toggle('rotate-left')
    burgerLines[2].classList.toggle('hide-line')
    $('.settings-column')[0].classList.toggle('mobile-menu')

  @showPasswordBlock: (e) ->
    e.preventDefault()
    position = $(this)
    $('#password_block').toggleClass('d-none')
    if $('#password_block').is(':visible')
      position.text('Скрыть')
    else
      position.text('Ввести пароль')
      $('#user_password, #user_password_confirmation, #user_current_password').val('')


  @toggleActiveSettingsPage: ->
    $("a.active-link").parents('li').addClass('active-link-underline');

$(document).on 'turbolinks:load', ->
  SettingsPage.init()
