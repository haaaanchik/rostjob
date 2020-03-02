window.addEventListener('turbolinks:load', function() {
    let order = new PrePublish();

    if(order.minus && order.plus){
        order.minus.addEventListener('click', function(){ order.reduce() });
        order.plus.addEventListener('click', function(){ order.increase() });
    }
});

class PrePublish {
    constructor() {
        this.minus = document.getElementById('minus');
        this.plus = document.getElementById('plus');
        this.number = document.getElementById('number-of-people');
        this.sum = document.getElementById('sum-to-pay');
        this.balance = document.getElementById('balance');
        this.price = document.getElementById('order_number_of_employees');
        this.totalSum = 0;
    }

    getNumber() {
        return this.number.textContent;
    }

    reduce() {
        let quantity = this.getNumber();
        if(quantity > 1){
            quantity--;
            this.number.textContent = quantity;
            this.totalSum = (quantity * this.price.dataset.customerPrice);
            this.sum.textContent = this.totalSum + ' руб.';
            this.setNumber();
            this.setBalanceAmount();
        }
    }

    increase() {
        let quantity = this.getNumber();
        quantity++;
        this.number.textContent = quantity;
        this.totalSum = (quantity * this.price.dataset.customerPrice);
        this.sum.textContent = this.totalSum + ' руб.';
        this.setNumber();
        this.setBalanceAmount();
    }

    setNumber() {
        document.getElementById('order_number_of_employees').value = this.number.textContent;
    }

    setBalanceAmount() {
        this.balance.textContent = (this.balance.dataset.balanceAmount - this.totalSum) + ' руб.';
    }
}
