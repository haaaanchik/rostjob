class Tickets
  @init: ->
    @bind()

  @bind: ->
    $('#main_treatment .treatment_list_tabs').on 'click', '[for$=_tickets]', @sendTicketsForm
    $('section.treatment_search').on 'click', '[for^=tickets_filter_]', @sendTicketsFormFilter
    $('.treatment_list_new').on 'click', @openModal
    $('.treatment-modal_back, .treatment_list_modal .btn-close').on 'click', @closeModal
    $('#admin_tickers').on 'click', '[for$=_tickets], .form-check-input', @findTicket

  @openModal: ->
    $('.treatment_list_modal').addClass('show')

  @closeModal: ->
    $('.treatment_list_modal').removeClass('show')

  @sendTicketsForm: () ->
    searchValue = $(this).prev().val()
    $('#q_state_waiting_fields_eq').val(searchValue)
    if searchValue == 'customer' || searchValue == 'contractor'
      $('#q_state_not_eq').val('closed')
    else
      $('#q_state_not_eq').val('')
    submitSearchForm()

  @sendTicketsFormFilter: ->
    submitSearchForm()

  submitSearchForm = () ->
    form = $('#ticket_search')[0]
    setTimeout(
      ->
        form.submit()
      300
    )

  @findTicket: ->
    $('#ticket_search').submit()

$(document).on 'turbolinks:load', ->
  Tickets.init()
