class Users
  @init: ->
    @bind()

  @bind: ->
    $('#admin_users_page').on 'click', 'tbody td[data-href]', @clickToUser
    $('#admin_users_page').on 'change', '#users_search select', @doSearch
    $('#admin_users_page').bind 'keyup', '#q_admin_search_fields_cont', @doSearch

  @clickToUser: ->
    window.location = $(this).data('href')

  @doSearch: (e) ->
    if (e.keyCode == 13 || e.type == 'change')
      $('#users_search').submit()
  
$(document).on 'turbolinks:load', ->
  Users.init()