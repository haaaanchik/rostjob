class Navbar
  @init: ->
    @initObserver()
    @bind()

  @initObserver: ->
    options = {}
    observer = new IntersectionObserver(onEntry, options)
    elements = $('section')
    for elm in elements
      observer.observe(elm)

  @bind: ->
    $('.burger').on 'click', @openCloseMobileMenu

  @openCloseMobileMenu: ->
    lines_arr = $('.burger span')
    $('.mobile-menu').slideToggle()
    lines_arr[0].classList.toggle('rotate-right');
    lines_arr[1].classList.toggle('rotate-left');
    lines_arr[2].classList.toggle('hide');

  onEntry = (entry) ->
    $(entry).each ->
      console.log(this)
      return
    return

$(document).on 'DOMContentLoaded', ->
  Navbar.init()