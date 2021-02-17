$(function() {
  class mobilePhoneModal {
    constructor() {
      this.callButton = document.querySelector('.js-call-help');
      this.closeButton = document.querySelector('.js-close-help');
      this.modal = document.querySelector('.js-help-window');
      this.init();
    }

    init(){
      if(this.callButton) this.callButton.addEventListener('click', this.openModal.bind(this));
      if(this.closeButton) this.closeButton.addEventListener('click', this.closeModal.bind(this));
    }

    openModal () {
      this.modal.classList.add('open');
      PITChatWidget.init()
    }

    closeModal () {
      this.modal.classList.remove('open')
      PITChatWidget.close()
    }
  }
  new mobilePhoneModal();

});