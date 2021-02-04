$(function() {

    class mobilePhoneModal {
      constructor() {
        this.callButton = document.querySelector('.js-call-help');
        this.closeButton = document.querySelector('.js-close-help');
        this.modal = document.querySelector('.js-help-window');
        this.init();
      }

      init(){
        console.log('init');
        if(this.callButton) this.callButton.addEventListener('click', this.openModal);
        if(this.closeButton) this.closeButton.addEventListener('click', this.closeModal);
      }

      openModal = () => {
          this.modal.classList.add('open');
      }

      closeModal = () => {
          this.modal.classList.remove('open')
      }

    }
  // .js-call-help
  //   help-content
  new mobilePhoneModal();

});