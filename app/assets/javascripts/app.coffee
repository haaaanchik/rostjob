#= require_self
#= require_tree ./components

window.RostJob = {}

ready = ->
  page = $('body').data('page')
  RostJob[page].init() if (RostJob[page])

$(document).ready ready