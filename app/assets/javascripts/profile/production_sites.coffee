class ProductionSites
  @init: ->
    @draggableInit()
    @bind()

  @bind: ->
    $('.mybtn').on 'click', @openAndCloseBlock
    $('.button-collapse').on 'click', @mobileMenuSlideToggle

  @draggableInit: ->
    itemArr = $('.js-table')
    i = 0
    while i < itemArr.length
      elem = itemArr[i]
      try
        Sortable.create elem,
          group:
            name: 'sorting'
            pull: true
          onEnd: (evt) ->
            toastr.info('Функционал временно недоступен')
          animation: 100
      catch e
        console.log 'не вышло создание движущихся элементов'
      i++

  @openAndCloseBlock: (evt) ->
    button = evt.target
    card = button.closest('.card-primary')
    card_body = card.querySelector('.js-table')
    if card_body.style.display == 'none'
      card_body.style.display = 'block'
    else
      card_body.style.display = 'none'
    $(this).children().toggleClass('fa-plus fa-minus')
    return

  @mobileMenuSlideToggle: ->
    $('.mobile-menu').slideToggle()
    return

$(document).on 'turbolinks:load', ->
  ProductionSites.init()