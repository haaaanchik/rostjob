#= require external/jquery-3.3.1.min
#= require rails-ujs

valid = (form_submit) ->
  email = $("input[name='user[email]']")
  $submit = $("button[name='customer']")
  regEx = /^[a-z0-9_-]+@[a-z0-9-]+\.[a-z]{2,6}$/i
  email.on 'change keyup input click', ->
    if form_submit.subm == true
      $submit.prop 'disabled', true # Если отправлено - выключено
    else if email.val().search(regEx) == 0
      $submit.prop 'disabled', false # Не отправлено, прошло валидацию
    else
      $submit.prop 'disabled', true # Не отправлено, не прошло валидацию
    return
  return

submit = (form_submit) ->
  email = $("input[name='user[email]']")
  $submit = $("button[name='customer']")
  regEx = /^[a-z0-9_-]+@[a-z0-9-]+\.[a-z]{2,6}$/i
  $submit.click ->
    if email.val().search(regEx) == 0
      $submit.prop 'disabled', true
      form_submit.subm = true
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
    #Количество экранов
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
  #Перекраска кружочков
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
    #Кол-во слайдов во viewbox
    #Т.к. отступ крайнего правого слайда не учитывается увеличиваем ширину viewboxa на отступ
    viewBox = parseInt($('.request_block_viewbox').css('width'), 10)
    slider.viewbox_slides = (viewBox + gap) / slider.slide_width
    #ReCheck навбара
    check_items slider
    return
  return

slider_options = (slider) ->
  #Количество слайдов
  slider.slides = $('.request_block_wrapper_item').length
  #Установка ширины полотна слайдера
  $('.request_block_wrapper').css 'grid-template-columns', 'repeat(' + slider.slides + ', 1fr)'
  #Ширина отдельного слайда
  gap = parseInt($('.request_block_wrapper').css('grid-column-gap'), 10)
  slideWidth = parseInt($('.request_block_wrapper_item').css('width'), 10)
  slider.slide_width = slideWidth + gap
  #Кол-во слайдов во viewbox
  #Т.к. отступ крайнего правого слайда не учитывается увеличиваем ширину viewboxa на отступ
  viewBox = parseInt($('.request_block_viewbox').css('width'), 10)
  slider.viewbox_slides = (viewBox + gap) / slider.slide_width
  #Инициализация навбара
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
    #Если кол-во слайдов на экране + смещение больше общего кол-ва слайдов смещение = 0
    if slider.offset + slider.viewbox_slides > slider.slides
      slider.offset = 0
    #Исключительно для читаемости
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
    #Если смещение < 0 то смещение = общ.кол-во слайдов - отображаемое кол-во слайдов
    if slider.offset < 0
      slider.offset = slider.slides - (slider.viewbox_slides)
    #Исключительно для читаемости
    offset = parseInt(slider.slide_width, 10) * slider.offset
    wrapper.css 'transform', 'translate(-' + offset + 'px, 0)'
    #Перекраска кружочков
    check_items slider
    return
  return

slider_navbar = (slider) ->
  wrapper = $('.request_block_wrapper')
  $('.navbar_item').click ->
    #Смещение = index+1 - кол-во видимых слайдов

    ###Да, я в курсе, что так себе выглядит при перемотке назад
    Если очень надо - могу подправить, но это надолго... наверное. Но, кажется, будет лучше вообще без навигации по item-ам
    ###

    slider.offset = $('.navbar_item').index($(this)) + 1 - (slider.viewbox_slides)
    if slider.offset < 0
      slider.offset = 0
    #Исключительно для читаемости
    offset = parseInt(slider.slide_width) * slider.offset
    wrapper.css 'transform', 'translate(-' + offset + 'px, 0)'
    check_items slider
    return
  return

$(document).ready ->
  form_submit = subm: false
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