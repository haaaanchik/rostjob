
let items_type_arr = document.querySelectorAll('.js-input-type');

for(let i = 0; i < items_type_arr.length; i++){
    let elem = items_type_arr[i];
    elem.addEventListener('click', changeActive);
}

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

let platform__header_arr = document.querySelectorAll('.js-platform__header');

for(let i = 0; i < platform__header_arr.length; i++){
    let elem = platform__header_arr[i];
    elem.addEventListener('click', changeView );
}

function changeView(e) {
    let parent = e.target.closest('.platform');
    $(parent).find('.js-platform__body').slideToggle();
    $(this).find('.js-arrow').toggleClass('rotated');
}

// Check all

let checkbox = document.getElementById('check_all');

checkbox.addEventListener('click', checkAll);

function checkAll() {
    if(checkbox.checked === true){
        let checkbox_arr = document.querySelector('.show-tab').querySelectorAll('input[type="checkbox"]');
        for (let i =0; i < checkbox_arr.length; i++){
            checkbox_arr[i].checked = true;
        }
    }
    if(checkbox.checked === false){
        let checkbox_arr = document.querySelector('.show-tab').querySelectorAll('input[type="checkbox"]');
        for (let i =0; i < checkbox_arr.length; i++){
            checkbox_arr[i].checked = false;
        }
    }

}