# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('label[for=proposal_accepted]').on('click', (event) ->
    element = $('#proposal_accepted')
    checked = element.prop('checked')
    if checked == false
      $('.proposal-submit-button').removeClass('disabled')
    else
      $('.proposal-submit-button').addClass('disabled')
  )

