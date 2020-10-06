class RostJob.LandingPagesIndustrial
  @init: ->
    @bind()
    @clientsSliderSlick()
    @sliderReviewsSlick()
    RostJob.LandingPages.init()

  @bind: ->
    $('.js-show-more').on 'click', @openDropdown
    $('.js-open-review').on 'click', @toggleReview

  @openDropdown: (e) ->
    $('.js-dropdown').not(e.target.nextElementSibling).removeClass('open');
    target = e.target
    if target.classList.contains('show-more')
      target.nextElementSibling.classList.toggle('open')

  @toggleReview: ->
    $(this).prev().toggleClass('review-opened')

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

  @sliderReviewsSlick: ->
    $('#slider-reviews').slick(
      centerMode: true
      centerPadding: '0'
      slidesToShow: 3
      focusOnSelect: false
      prevArrow: $('.slider-reviews-prev')
      nextArrow: $('.slider-reviews-next')
      responsive: [
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
    $('#slider-reviews').slickLightbox()
