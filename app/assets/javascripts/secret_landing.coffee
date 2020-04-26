#= require external/jquery-3.3.1.min
#= require rails-ujs
#= require navbar

valid = (form_submit) ->
  email = $("input[name='user[email]']")
  $submit = $("button[name='customer']")
  regEx = /^([a-z0-9_-]+\.)*[a-z0-9_-]+@[a-z0-9_-]+(\.[a-z0-9_-]+)*\.[a-z]{2,6}$/i
  email.on 'change keyup input click', ->
    if form_submit.subm == true
      $submit.prop 'disabled', true
    else if email.val().search(regEx) == 0
      $submit.prop 'disabled', false
    else
      $submit.prop 'disabled', true
    return
  return

submit = (form_submit) ->
  email = $("input[name='user[email]']")
  $submit = $("button[name='customer']")
  regEx = /^([a-z0-9_-]+\.)*[a-z0-9_-]+@[a-z0-9_-]+(\.[a-z0-9_-]+)*\.[a-z]{2,6}$/i
  $submit.click ->
    if email.val().search(regEx) == 0
      $submit.prop 'disabled', false
    else
      email.parent().addClass 'alert'
      $submit.prop 'disabled', true
    return
  return

scroll = ->
  $(window).scroll ->
    if $(window).scrollTop() + innerHeight >= $(document).height() - 160
      $('.header_scroll_down').css
        'visibility': 'hidden'
        'opacity': 0
      $('.header_scroll_top').css
        'visibility': 'visible'
        'opacity': 1
    else
      $('.header_scroll_down').css
        'visibility': 'visible'
        'opacity': 1
      $('.header_scroll_top').css
        'visibility': 'hidden'
        'opacity': 0
    return
  return

scroll_down = ->
  button = $('.header_scroll_down')
  button.click ->
    YOffset = parseInt(pageYOffset / innerHeight, 10)
    $('html, body').animate { scrollTop: (YOffset + 1) * innerHeight + 40 }, 'slow'
    return
  return

scroll_top = ->
  button = $('.header_scroll_top')
  button.click ->
    $('html, body').animate { scrollTop: 0 }, 'slow'
    return
  return

check_items = (slider) ->
  i = 0
  while i < slider.slides
    if i >= slider.offset and i < slider.offset + slider.viewbox_slides
      $('.navbar_item:eq('+i+')').addClass('active')
    else
      $('.navbar_item:eq('+i+')').removeClass('active')
    i++
  return

slider_resize = (slider) ->
  $(window).resize ->
    gap = parseInt($('.request_block_wrapper').css('grid-column-gap'), 10)
    viewBox = parseInt($('.request_block_viewbox').css('width'), 10)
    slider.viewbox_slides = (viewBox + gap) / slider.slide_width
    check_items slider
    return
  return

slider_options = (slider) ->
  slider.slides = $('.request_block_wrapper_item').length
  $('.request_block_wrapper').css 'grid-template-columns', 'repeat(' + slider.slides + ', 1fr)'
  gap = parseInt($('.request_block_wrapper').css('grid-column-gap'), 10)
  slideWidth = parseInt($('.request_block_wrapper_item').css('width'), 10)
  slider.slide_width = slideWidth + gap
  viewBox = parseInt($('.request_block_viewbox').css('width'), 10)
  slider.viewbox_slides = (viewBox + gap) / slider.slide_width
  i = 0
  while i < slider.slides
    $('.navbar').append("<span class='navbar_item'></span>")
    if i < slider.viewbox_slides
      $(".navbar_item:eq("+i+")").addClass('active')
    i++
  return

next_slide = (slider) ->
  button = $('.request_block_nav .arrow_right')
  wrapper = $('.request_block_wrapper')
  button.click ->
    slider.offset++
    if slider.offset + slider.viewbox_slides > slider.slides
      slider.offset = 0

    offset = parseInt(slider.slide_width, 10) * slider.offset
    wrapper.css 'transform', 'translate(-' + offset + 'px, 0)'
    check_items slider
    return
  return

prev_slide = (slider) ->
  button = $('.request_block_nav .arrow_left')
  wrapper = $('.request_block_wrapper')
  button.click ->
    slider.offset--
    if slider.offset < 0
      slider.offset = slider.slides - (slider.viewbox_slides)

    offset = parseInt(slider.slide_width, 10) * slider.offset
    wrapper.css 'transform', 'translate(-' + offset + 'px, 0)'
    check_items slider
    return
  return

slider_navbar = (slider) ->
  wrapper = $('.request_block_wrapper')
  $('.navbar_item').click ->
    slider.offset = $('.navbar_item').index($(this)) + 1 - (slider.viewbox_slides)
    if slider.offset < 0
      slider.offset = 0

    offset = parseInt(slider.slide_width) * slider.offset
    wrapper.css 'transform', 'translate(-' + offset + 'px, 0)'
    check_items slider
    return
  return

$(document).ready ->
  form_submit = 
    subm: false
  slider = 
    slides: 0
    slide_width: 0
    viewbox_slides: 0
    offset: 0
  valid(form_submit)
  submit(form_submit)
  slider_options(slider)
  next_slide(slider)
  prev_slide(slider)
  slider_navbar(slider)
  slider_resize(slider)
  scroll_down()
  scroll_top()
  scroll()
  return