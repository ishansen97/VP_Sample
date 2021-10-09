var confirmationModal = function () {
  let modalTemplate = `
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="confirm-modal-container vp-rapid-modal-container">
          <div class="modal-header">
            <slot name="header">
              <label class="label-text">{{_componentsDataStore.confirmationModal.modalTitle}}</label>
            </slot>
          </div>

          <div class="vp-section mb-0" v-html="_componentsDataStore.confirmationModal.modalInfo"/>
          <div class="modal-footer">
            <slot name="footer">
            <input type="button" value="Continue" class="modal-default-button btn" @click="continueClick() ">
            <input type="button" value="Cancel" class="modal-default-button btn mr-3" @click="$emit(_constants.modalClose.confirm)">
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
  `;

  Vue.component("confirmation-modal", {
    template: modalTemplate,
    methods: {
      continueClick(){
        this.$emit(_constants.modalClose.confirm)
        _componentsDataStore.confirmationModal.confirmFunction();
      }
    }
  });
};



