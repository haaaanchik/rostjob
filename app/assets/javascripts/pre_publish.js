$(function() {
    let minus = document.getElementById('minus');
    let plus = document.getElementById('plus');
    let number = document.getElementById('number-of-people');
    let sum = document.getElementById('sum-to-pay');
    let price = 12000;

    if(minus && plus){
        minus.addEventListener('click', reduce);
        plus.addEventListener('click', increase);
    }

    function getNumber(){
        return number.textContent;
    }

    function reduce() {
        let quantity = getNumber();
        if(quantity > 1){
            quantity--;
            number.textContent = quantity;
            sum.textContent = (quantity * price) + ' руб.';
        }
    }

    function increase() {
        let quantity = getNumber();
        quantity++;
        number.textContent = quantity;
        sum.textContent = (quantity * price) + ' руб.';
    }

});
