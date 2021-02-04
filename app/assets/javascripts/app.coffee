#= require_self
#= require_tree ./components

window.RostJob = {}

ready = ->
  RostJob.SearchBase.init()
  PITChatWidget.init()
  page = $('body').data('page')
  RostJob[page].init() if (RostJob[page])

$(document).ready ready