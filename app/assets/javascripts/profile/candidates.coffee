class Candidates
  @init: ->
    @bind()

  @bind: ->
    $('.candidate-comment').on 'keyup', @searchEnterComment

  @searchEnterComment: (e) ->
    e.preventDefault()
    toastr.info('Добавление комментария временно недоступен!')

$(document).on 'turbolinks:load', ->
  Candidates.init()

$(document).on('click', '[id^=candidate_filter_]', ->
  form = $('#proposal_employee_search')[0]
  form.submit()
)
