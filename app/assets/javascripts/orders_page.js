$(document).ready(function(){

	let moreDetailsArr = document.querySelectorAll('.js-moreDetails');
	if(moreDetailsArr.length > 0) moreDetailsArr.forEach(el => el.addEventListener('click', toggleHideDescription));

	function toggleHideDescription(e){
		const order = e.target.closest('.order');
		const arrow = order.querySelector('.js-arrow');
		// Вращаю стрелку
		arrow.classList.toggle('rotate');
		const moreDetails = order.querySelector('.moreDetails__text');
		// Заменяю текст
		if(!arrow.classList.contains('rotate')){
			moreDetails.textContent = 'Подробнее';
		}
		else {
			moreDetails.textContent = 'Свернуть';
		}
		const hideDescriptionBlock = order.querySelector('.js-hide-description');
		// Скрываю или отображаю скрытое описание
		hideDescriptionBlock.classList.toggle('hide');
	}

	let selectTitlesArr = document.querySelectorAll('.js-select-title');
	if(selectTitlesArr.length > 0) selectTitlesArr.forEach(el => el.addEventListener('click', toggleHideSelects));

  (function() {
    $(document).on('click', '.js-btn-long', function() {
      var form;
      form = $('#profession-city-form');
      return form.submit();
    });

  }).call(this);

	function toggleHideSelectsFromButtons(e) {
		const button = e.target;
		const form = button.closest('form');
		form.classList.toggle('hide');
		const cityBlock = button.closest('.select');
		let arrow = cityBlock.querySelector('.js-arrow');
		arrow.classList.toggle('rotate');
	}

  let citiesContainer = document.querySelector('.cities-container');
  let profContainer = document.querySelector('.professions-container');

	function toggleHideSelects(e){
		// Скрываю или отображаю
    const container = e.target.nextElementSibling;
    if(container === profContainer && !citiesContainer.classList.contains('hide')){
      citiesContainer.classList.add('hide');
      citiesContainer.previousElementSibling.querySelector('.js-arrow').classList.remove('rotate');
    }
    if(container === citiesContainer &&  !profContainer.classList.contains('hide')){
      profContainer.classList.add('hide');
      profContainer.previousElementSibling.querySelector('.js-arrow').classList.remove('rotate');
    }
		e.target.nextElementSibling.classList.toggle('hide');
		const arrow = e.target.querySelector('.js-arrow');
		// Вращаю стрелку
		arrow.classList.toggle('rotate');
	}

	const checkAllButtons = document.querySelectorAll('.js-checkAll');
	if(checkAllButtons.length > 0) checkAllButtons.forEach(el => el.addEventListener('click', checkAllItems));

	function checkAllItems(e){
		const button = e.target;
		const selectButtonsBlock = button.closest('.select__buttons');
		const selectOptionsBlock = selectButtonsBlock.previousElementSibling;
		let checkboxesArr = selectOptionsBlock.querySelectorAll('input');
		checkboxesArr.forEach(el => el.checked = true);
	}

	const clearAllButtons = document.querySelectorAll('.js-clearAll');
	if(clearAllButtons.length > 0) clearAllButtons.forEach(el => el.addEventListener('click', clearAllItems));

	function clearAllItems(e) {
		const button = e.target;
		const selectButtonsBlock = button.closest('.select__buttons');
		const selectOptionsBlock = selectButtonsBlock.previousElementSibling;
		let checkboxesArr = selectOptionsBlock.querySelectorAll('input');
		checkboxesArr.forEach(el => el.checked = false);
	}

});