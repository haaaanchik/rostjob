class RostJob.SearchBase
  @init: ->
    @bind()

  @bind: ->
    $('.search_candidates, .search-input, #search-input ').on 'keyup', removingSpaces

  removingSpaces = () ->
    val = $(this).val().replace(/ +(?= )/g,'')
    $(this).val(val)
