class SettingsPage
  @init: ->
    @bind()

  @bind: ->
    $('.burger').on 'click', @openAndCloseMobileMenu

  @openAndCloseMobileMenu: ->
    burgerLines = $('.burger span')
    burgerLines[0].classList.toggle('rotate-right')
    burgerLines[1].classList.toggle('rotate-left')
    burgerLines[2].classList.toggle('hide-line')
    $('.settings-column')[0].classList.toggle('mobile-menu')

$(document).on 'turbolinks:load', ->
  SettingsPage.init()
