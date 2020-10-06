class RostJob.LandingPagesFreelance
  @init: ->
    @initSlick()
    RostJob.LandingPages.init()

  @initSlick: ->
    $('.slider-container').slick(
      autoplay: true
      autoplaySpeed: 3000
      infinite: true
      slidesToShow: 3
      slidesToScroll: 3
      arrows: false
      variableWidth: true
      responsive: [
        {
          breakpoint: 1250
          settings:
            slidesToShow: 2
            slidesToScroll: 2
            variableWidth: false
        }
        {
          breakpoint: 768
          settings:
            slidesToShow: 1
            slidesToScroll: 1
            variableWidth: false
        }
      ]
    )