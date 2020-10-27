class RostJob.ProfileTicketsShow
  @init: ->
    @bind()

  @bind: ->
    $('.ready-text-examples').on 'click', '.text-example[data-toggle=popover]', @hideOtherPopover
    $('.content-wrapper').on 'click', @hideAllPovers

  @hideOtherPopover: (e) ->
    e.stopPropagation()
    $('.ready-text-examples .text-example[data-toggle=popover]').not(this).popover('hide')

  @hideAllPovers: ->
    $('.ready-text-examples .text-example').popover('hide')
