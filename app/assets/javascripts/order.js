function platforms_nav(){
	//Согласен, выглядит жутко.
	let text = ".platforms_list_platform_bottom_text";
	let navInfo = ".platforms_list_platform_bottom_nav_info";
	let textInfo = ".platforms_list_platform_bottom_text_info";
	let navVacancies = ".platforms_list_platform_bottom_nav_vacancies";
	let textVacancies = ".platforms_list_platform_bottom_text_vacancies";
	let navContacts = ".platforms_list_platform_bottom_nav_contacts";
	let textContacts = ".platforms_list_platform_bottom_text_contacts";
	$(navInfo).click(function(){
		$(this).siblings().removeClass("show");
		$(this).addClass("show");
		$(this).parent().siblings(text).children().removeClass("show");//Убрать отображение двух других
		$(this).parent().siblings(text).children(textInfo).addClass("show");
	});
	$(navVacancies).click(function(){
		$(this).siblings().removeClass("show");
		$(this).addClass("show");
		$(this).parent().siblings(text).children().removeClass("show");//Убрать отображение двух других
		$(this).parent().siblings(text).children(textVacancies).addClass("show");
	});
	$(navContacts).click(function(){
		$(this).siblings().removeClass("show");
		$(this).addClass("show");
		$(this).parent().siblings(text).children().removeClass("show");//Убрать отображение двух других
		$(this).parent().siblings(text).children(textContacts).addClass("show");
	})
}

$(document).ready(function(){
	platforms_nav();
});