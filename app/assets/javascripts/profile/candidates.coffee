class Candidates
  @init: ->
    @bind()

  @bind: ->
    $('.candidate-comment').on 'keyup', @searchEnterComment
    $('.clickable-candidate').on 'click', @openCandidate
    $('.js-filters').on 'click', @openFilters

  @searchEnterComment: (e) ->
    e.preventDefault()
    toastr.info('Добавление комментария временно недоступен!')

  @openCandidate: ->
    window.location = $(this).data('href')

  @openFilters: ->
    $('.js-filters-dropdown').toggleClass('filters-show')
    $('.js-filters > img').toggleClass('rotate')
    $('#worksheet').toggleClass('max-content')

$(document).on 'turbolinks:load', ->
  Candidates.init()

$(document).on('click', '[id^=candidate_filter_]', ->
  form = $('#proposal_employee_search')[0]
  form.submit()
)
