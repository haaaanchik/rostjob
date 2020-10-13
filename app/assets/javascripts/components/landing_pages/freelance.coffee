class RostJob.LandingPagesFreelance
  @init: ->
    @initSlick()
    RostJob.LandingPages.init()
    @showCurrentSlide(@getCurrentSlide())
    $(window).scroll( () =>
      @scrollTracking()
    );
    $(document).ready( () =>
      @scrollTracking()
    );

  @initSlick: ->
    slider = $('.slider-container')
    slider.slick(
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
    slider.on('afterChange', (event, slick, currentSlide, nextSlide) =>
      @showCurrentSlide(currentSlide)
    )
    $('.jsPrevSlide').on('click', () =>
      slider.slick('slickPrev')
    )
    $('.jsNextSlide').on('click', () =>
      slider.slick('slickNext')
    )

  @getCurrentSlide: ->
    return $('.slider-container').slick('slickCurrentSlide');

  @showCurrentSlide: (slideNumber) ->
    slider = $('.slider-container')
    sliderLength = slider.slick('getSlick').$slides.length
    slidesToShow = slider.slick('getSlick').options.slidesToShow
    slideNumber = slideNumber / slidesToShow + 1
    $('#slideNumber').text(slideNumber)
    @countAndShowAllSlides(slidesToShow, sliderLength)

  @countAndShowAllSlides: (slidesToShow, sliderLength) ->
    allSlides = Math.ceil(sliderLength / slidesToShow)
    $('#allSlides').text(allSlides)

  @block_show = null;

  @scrollTracking: () ->
    wt = $(window).scrollTop();
    wh = $(window).height();
    et = $('.work-results').offset().top;
    eh = $('.work-results').outerHeight();

    if (wt + wh >= et && wt + wh - eh * 2 <= et + (wh - eh))
      if (@block_show == null || @block_show == false)
        @animateRounds()
      @block_show = true;
    else
      @block_show = false;

  @animateRounds: ->
    $('.round.big').addClass('animate__animated animate__zoomIn animate__delay-1s')
    $('.round.middle').addClass('animate__animated animate__zoomIn animate__delay-2s')
    $('.round.small').addClass('animate__animated animate__zoomIn animate__delay-3s')