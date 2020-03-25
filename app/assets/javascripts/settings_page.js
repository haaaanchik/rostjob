$(function() {
    console.log('settings');
	let switchArr = document.querySelectorAll('li[data-switch]');
	for(let i=0; i< switchArr.length;i++){
	    switchArr[i].addEventListener('click', changeSettingsBlock);
    }

	function changeSettingsBlock() {
        let switchTo = this.dataset.switch;
        let  block = null;
        block = document.getElementById(switchTo);
        clearShow();
        if(block != null){
            block.classList.toggle('show');
        }
    }

	function clearShow() {
        let arr = document.querySelectorAll('.show');
        for(let i=0; i < arr.length;i++){
            arr[i].classList.remove('show');
        }
    }

	/* Mobile menu */

    let burger = document.querySelector('.burger');
    let burgerLines = document.querySelectorAll('.burger span');

    let firstLine = burgerLines[0];
    let secondLine = burgerLines[1];
    let thirdLine = burgerLines[2];

    if(burger){
        burger.addEventListener('click', openAndCloseMobileMenu);
    }

    let menu = document.querySelector('.settings-column');

    function openAndCloseMobileMenu() {

        firstLine.classList.toggle('rotate-right');
        secondLine.classList.toggle('rotate-left');
        thirdLine.classList.toggle('hide-line');

        menu.classList.toggle('mobile-menu');

    }


});
