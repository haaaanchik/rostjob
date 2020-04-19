class Settings
  @init: ->
    @bind()

  @bind: ->
    $('.mailing-list-management').on 'click', 'form#setting input[type="checkbox"]', @clickChecbox
     
  @clickChecbox: ->
    $(this).parents('form#setting').submit()
  
$(document).on 'turbolinks:load', ->
  Settings.init()