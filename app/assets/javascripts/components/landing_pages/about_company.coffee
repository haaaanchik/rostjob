class RostJob.LandingPagesAboutCompany
  @init: ->
    @clientsSliderSlick()
    RostJob.LandingPagesBase.init()

  @clientsSliderSlick: ->
    $('#clients-slider').slick(
      infinite: true
      slidesToShow: 6
      slidesToScroll: 1
      autoplay: true
      autoplaySpeed: 2000
      prevArrow: $('.clients-slider-arrow-left')
      nextArrow: $('.clients-slider-arrow-right')
      responsive: [
        {
          breakpoint: 1200
          settings:
            slidesToShow: 4
            slidesToScroll: 1
        },
        {
          breakpoint: 992
          settings:
            slidesToShow: 2
            slidesToScroll: 1
        },
        {
          breakpoint: 768
          settings:
            slidesToShow: 1
            slidesToScroll: 1
        }
      ]
    )