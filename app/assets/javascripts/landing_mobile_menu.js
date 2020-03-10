console.log('mobile-menu-ready');

let lines_arr = document.querySelectorAll('.burger span');
console.log(lines_arr);
let firstLine = lines_arr[0];
let secondLine = lines_arr[1];
let thirdLine = lines_arr[2];
let mobileMenu = $('.mobile-menu');

if(document.querySelector('.burger')){
    document.querySelector('.burger').addEventListener('click', openCloseMobileMenu);
}

function openCloseMobileMenu() {
    mobileMenu.slideToggle();
    firstLine.classList.toggle('rotate-right');
    secondLine.classList.toggle('rotate-left');
    thirdLine.classList.toggle('hide');
}

