class Staffers
  @init: ->
    @initSelect2()

  @initSelect2: ->
    return unless $('#staffer_staffer_roles').length

    $('#staffer_staffer_roles').select2()

$(document).on 'turbolinks:load', ->
  Staffers.init()