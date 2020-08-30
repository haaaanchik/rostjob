class RostJob.AdminZarplataSearch
  @init: ->
    @initRubricSelect2()
    @initSpecialtySelect2()
    @initCitySelect2()

  @initRubricSelect2: ->
    $('#zarplata_rubrics_id').select2(
      placeholder: 'Выберите рубрику'
      minimumResultsForSearch: Infinity
      ajax:
        url: '/search_zarplata_rubrics'
        dataType: 'json'
        processResults: (data) ->
          {
            results: $.map(data.rubrics, (rubric) ->
              return {
                id: rubric.id,
                text: rubric.title,
                diabled: $('li.select2-selection__choice[title="'+rubric.title+'"]').length
              }
            )
          }
    )

  @initSpecialtySelect2: ->
    $('#zarplata_rubrics_specialities').select2(
      placeholder: 'Введите специализацию'
      minimumResultsForSearch: Infinity
      ajax:
        url: '/search_zarplata_specialties'
        data: (params) ->
          term: params.term
          parent_id: $('#zarplata_rubrics_id').val()
        dataType: 'json'
        processResults: (data) ->
          {
            results: $.map(data.rubrics, (speciality) ->
              return {
                id: speciality.id,
                text: speciality.title,
                diabled: $('li.select2-selection__choice[title="'+speciality.title+'"]').length
              }
            )
          }
    )

  @initCitySelect2: ->
    $('#zarplata_contact_city').select2(
      placeholder: 'Введите город'
      ajax:
        url: '/search_zarplata_city'
        data: (params) ->
          term: params.term
        dataType: 'json'
        processResults: (data) ->
          {
            results: $.map(data.geo, (geo) ->
              return {
                id: geo.id,
                text: geo.name,
                diabled: $('li.select2-selection__choice[title="'+geo.name+'"]').length
              }
            )
          }
    ).on 'select2:open', ->
      $('#zarplataRuPublishVacancy').removeAttr('tabindex')
    .on 'select2:close', ->
      $('#zarplataRuPublishVacancy').attr('tabindex', -1)
