class RostJob.ProfileTicketsShow
  @init: ->
    @bind()

  @bind: ->
    $('.ready-text-examples').on 'click', '.text-example', @hideOtherPopover
    $('.content-wrapper').on 'click', @hideAllPovers

  @hideOtherPopover: (e) ->
    e.stopPropagation()
    $('.ready-text-examples .text-example').not(this).popover('hide')

  @hideAllPovers: ->
    $('.ready-text-examples .text-example').popover('hide')
