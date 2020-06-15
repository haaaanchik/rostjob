class Specializations
  @init: ->
    @initSearchPositions()

  @bind: ->


  @initSearchPositions: ->
    return unless $('#specialization_position_ids').length

    $('#specialization_position_ids').select2(
      placeholder: 'Введите прфоессию'
      ajax:
        url: '/search_admin_position'
        data: (params) ->
          q: { title_cont: params.term }
        dataType: 'json'
        processResults: (data) ->
          {
            results: $.map(data, (position) ->
              return {
                id: position.id,
                text: position.title,
                diabled: $('li.select2-selection__choice[title="'+position.title+'"]').length
              }
            )
          }
    )

$(document).on 'turbolinks:load', ->
  Specializations.init()
