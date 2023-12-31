class ProductionSites
  @init: ->
    @draggableInit()
    @bind()

  @bind: ->
    $('.search-production-site').on 'keyup', @searchProductinSite
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

  @searchProductinSite: (e) ->
    e.preventDefault()
    toastr.info('Поиск временно недоступен!')

  @mobileMenuSlideToggle: ->
    $('.mobile-menu').slideToggle()
    return

$(document).on 'turbolinks:load', ->
  ProductionSites.init()