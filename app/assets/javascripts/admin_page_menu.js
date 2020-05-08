$(document).ready(() => {

    let menuButton = $("#admin-page .toggle-menu-button");
    let menu = $('#admin-page #slide-out');

    menuButton.on('click', function(){
        menu.toggleClass('fixed');
        menuButton.toggleClass('opened');
    });

    $('.js-prevent').on('click', function (e) {
        e.preventDefault();
        // closeOpenedSublists();
        let sublist = this.nextElementSibling;
        if( sublist.classList.contains('collapsible-body')){
            sublist.classList.toggle('open');
        }
    });

    function closeOpenedSublists() {
        let sublists = document.querySelectorAll('#admin-page .collapsible-body.open');
        for(let i=0; i < sublists.length; i++ ){
            sublists[i].classList.remove('open');
        }
    }

});