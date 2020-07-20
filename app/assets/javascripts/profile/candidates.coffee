class Candidates
  @init: ->
    @bind()

  @bind: ->
    $('textarea.candidate-comment').on 'blur', @writeComment
    $('.clickable-candidate').on 'click', @openCandidate
    $('.js-filters').on 'click', @openFilters

  @writeComment: ->
    byWho = $(this).attr('id')
    if byWho == "by_contractor"
      toastr.info('Добавление комментария временно недоступен!')
      e.preventDefault()
      return

    commentText = $(this).val()
    candidateId = $(this).parents('.request').data('proposal_employee_id')
    url = '/profile/candidates/'+candidateId+'/comment'

    $.ajax url,
      method: 'PUT'
      dataType: 'json'
      data:
        comment: commentText
      error: (data) ->
        $(this).css('border: 1px solid red')
        console.log(data.responseJSON.message)
    return


  @openCandidate: ->
    window.location = $(this).data('href')

  @openFilters: ->
    $('.js-filters-dropdown').toggleClass('filters-show')
    $('#filters img').toggleClass('rotate')
    if ( $('.js-filters-dropdown').hasClass('filters-show') )
      filtersHeight = $('.js-filters-dropdown').outerHeight(true)
      worksheetHeight = $('#worksheet').height();
      filtersHeightPercent = (filtersHeight / worksheetHeight) * 100
      worksheetsHeight = ( $('.worksheets').height() / worksheetHeight) * 100
      console.log(filtersHeightPercent + '%')
      console.log(worksheetsHeight + '%' )
      $('.worksheets').css('height', (worksheetsHeight - filtersHeightPercent ) + '%')
    else
      $('.worksheets').css('height', '')

$(document).on 'turbolinks:load', ->
  Candidates.init()

$(document).on('click', '[id^=candidate_filter_]', ->
  form = $('#proposal_employee_search')[0]
  form.submit()
)
