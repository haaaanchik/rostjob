class RostJob.ProfileTicketsShow
  @init: ->
    @bind()

  @bind: ->
    $('.ready-text-examples').on 'click', '.text-example[data-toggle=popover]', @hideOtherPopover
    $('.content-wrapper').on 'click', @hideAllPovers
    $('#precedent_button').on 'click', @precendetClicked

  @hideOtherPopover: (e) ->
    e.stopPropagation()
    $('.ready-text-examples .text-example[data-toggle=popover]').not(this).popover('hide')

  @hideAllPovers: ->
    $('.ready-text-examples .text-example').popover('hide')

  @precendetClicked: (e) ->
    $(this).addClass('disabled')
    e.preventDefault()
