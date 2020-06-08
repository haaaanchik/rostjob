class SettingsPage
  @init: ->
    @bind()
    @toggleActiveSettingsPage()

  @bind: ->
    $('.burger').on 'click', @openAndCloseMobileMenu
#    $("a.active-link").on 'click', @toggleActiveSettingsPage

  @openAndCloseMobileMenu: ->
    burgerLines = $('.burger span')
    burgerLines[0].classList.toggle('rotate-right')
    burgerLines[1].classList.toggle('rotate-left')
    burgerLines[2].classList.toggle('hide-line')
    $('.settings-column')[0].classList.toggle('mobile-menu')

  @toggleActiveSettingsPage: ->
    console.log(123)
    $("a.active-link").parents('li').addClass('active-link-underline');

$(document).on 'turbolinks:load', ->
  SettingsPage.init()
