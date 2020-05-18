class Admin_menu
  @init: ->
    @menuButtonToggle()
    @prevent()

  @menuButtonToggle: ->
    menuButton = $("#admin-page .toggle-menu-button")
    menu = $('#admin-page #slide-out')
    menuButton.on 'click', ->
      menu.toggleClass('fixed')
      menuButton.toggleClass('opened')

  @prevent: ->
    links = $('.js-prevent')
    links.on 'click', (e) ->
      e.preventDefault()
      sublist = this.nextElementSibling
      if sublist.classList.contains('collapsible-body')
        sublist.classList.toggle('open')

$(document).on 'turbolinks:load', ->
  Admin_menu.init()