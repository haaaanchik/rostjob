#= require external/jquery-3.3.1.min
#= require external/popper.min
#= require external/bootstrap
#= require external/jquery-ui.min
#= require external/mdb
#= require external/mdb.ru_RU
#= require external/jquery.inputmask.bundle.min
#= require rails-ujs
#= require jquery.turbolinks
#= require turbolinks
#= require external/turbolinks-compatibility
#= require_tree .

$(document).ready ->
  new WOW().init()
  $('.mdb-select').material_select()
  $(window).scroll ->
    if $(this).scrollTop() > 50
      $('[href="#top-section"]').fadeIn()
    else
      $('[href="#top-section"]').fadeOut()
    return
  return