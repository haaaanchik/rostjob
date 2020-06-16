class Analytics
  @init: ->
    @dataPickerInit()
    @bind()
    @ordersDataTableInit()

  @bind: ->
    $('#orders_info_page').on 'change', '#orders_info_search select', @doSearch
    $('#orders_info_page').on 'keyup', '#q_user_full_name_or_title_cont', @doSearch
    $('#orders_info_page').on 'change', '#date-picker-date', @doSearch
    $('#orders_info_page').on 'click', '#export_pdf', @exportPDF

  @dataPickerInit: ->
    $('.datepicker').pickadate({
      formatSubmit: false,
      dateFormat: "yy-mm-dd"
    })
  
  @doSearch: (e)->
    if (e.keyCode == 13 || e.type == 'change')
      $('#orders_info_search').submit()

  @ordersDataTableInit: ->
    $.fn.dataTable.moment('DD.MM.YYYY')

    $('#order_table').DataTable
      searching: false
      dom: 'Bfrtip'
      pageLength: 20
      order: []
      bInfo: false
      language:
        paginate:
          previous: '<<'
          next: '>>'
      buttons: [ 
        $.extend(true, {}, @fixNewLine(),
        extend: 'pdfHtml5'
        orientation: 'landscape'
        pageSize: 'TABLOID'
        download: 'open'
        title: null  
        customize: (doc) ->
          doc.content[0].alignment = 'right'
          doc.styles.tableHeader = 
            background: 'white'
            alignment: 'center'
            border: '1px solid black'

          now = new Date()
          jsDate = now.getDate()+'-'+(now.getMonth()+1)+'-'+now.getFullYear()

          doc['footer'] = (page, pages) ->
            {
              columns: [
                {
                  alignment: 'left'
                  text: [
                    'Сформирована '
                    { text: jsDate.toString() }
                  ]
                }
                {
                  alignment: 'right'
                  text: [
                    'Страница '
                    { text: page.toString() }
                    ' из '
                    { text: pages.toString() }
                  ]
                }
              ]
              margin: 20
            }

          objLayout = {}
          objLayout['hLineWidth'] = (i) ->
            .5
          objLayout['vLineWidth'] = (i) ->
            .5
          objLayout['hLineColor'] = (i) ->
            '#aaa'
          objLayout['vLineColor'] = (i) ->
            '#aaa'

          doc.content[0].layout = objLayout
        ) ]

  @exportPDF: (e) ->
    e.preventDefault()
    $('.dt-button.buttons-pdf').click()
  
  @fixNewLine: ->
    exportOptions: 
      format: 
        body: (data, column, row) ->
          data = data.replace( /<br\s*\/?>/ig, "\n" )
          data = data.replace( /<b\s*\/?>/ig, '' )
          data = data.replace( /<\/b\s*\/?>/ig, '' )

$(document).on 'turbolinks:load', ->
  Analytics.init()