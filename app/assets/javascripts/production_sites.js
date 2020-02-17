window.addEventListener('turbolinks:load', function() {
    let items_type_arr = document.querySelectorAll('.js-input-type');

    for(let i = 0; i < items_type_arr.length; i++){
        let elem = items_type_arr[i];
        elem.addEventListener('click', changeActive);
    }

    let platform__header_arr = document.querySelectorAll('.js-platform__header');

    for(let i = 0; i < platform__header_arr.length; i++){
        let elem = platform__header_arr[i];
        elem.addEventListener('click', changeView );
    }

    // Check all
    let checkbox = document.getElementById('check_all');
    if(checkbox){
        checkbox.addEventListener('click', checkAll);
    }

    // tinymce.init({
    //     selector: '.tinymce',
    //     menubar: false,
    //     toolbar: 'undo redo | bold italic underline strikethrough | fontselect fontsizeselect formatselect | alignleft aligncenter alignright alignjustify | outdent indent |  numlist bullist checklist | forecolor backcolor casechange permanentpen formatpainter removeformat | pagebreak | charmap emoticons | fullscreen  preview save print | insertfile image media pageembed template link anchor codesample | a11ycheck ltr rtl | showcomments addcomment',
    // });
});

function changeActive(e) {
    let active = document.querySelector('.js-input-type.active');
    active.classList.remove('active');

    let data_tab;
    clearShown();
    if(e.target.classList.contains('js-input-type')){
        e.target.classList.add('active');
        data_tab = e.target.getAttribute('data-target');
    }
    else {
        e.target.parentElement.classList.add('active');
        data_tab = e.target.parentElement.getAttribute('data-target');
    }
    document.querySelector(`[data-tab="${data_tab}"]`).classList.toggle('show-tab');
}

function clearShown(){
    if(document.querySelector('.show-tab')){
        document.querySelector('.show-tab').classList.remove('show-tab');
    }
}

function changeView(e) {
    let parent = e.target.closest('.platform');
    $(parent).find('.js-platform__body').slideToggle();
    $(this).find('.js-arrow').toggleClass('rotated');
}

function checkAll() {
    if(this.checked === true){
        let checkbox_arr = document.querySelector('.show-tab').querySelectorAll('input[type="checkbox"]');
        for (let i =0; i < checkbox_arr.length; i++){
            checkbox_arr[i].checked = true;
        }
    }
    if(this.checked === false){
        let checkbox_arr = document.querySelector('.show-tab').querySelectorAll('input[type="checkbox"]');
        for (let i =0; i < checkbox_arr.length; i++){
            checkbox_arr[i].checked = false;
        }
    }

}