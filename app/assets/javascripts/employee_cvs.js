$(function() {

    $('.js-arrow').on('click', slideToggle );

    function slideToggle() {
        $(this).parent('.card-header').next('.js-slide-elem').slideToggle();
    }

    $('.js-close-popup').on('click', function () {
        $('.popup').css('display', 'none');
    });

});