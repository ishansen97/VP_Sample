var informationModal = function () {
  let modalTemplate = `
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="vp-rapid-modal-container">
          <div class="modal-header">
            <slot name="header">
              <label class="label-text">{{_componentsDataStore.informationModal.modalTitle}}</label>
              <button type="button" value="" class="modal-default-button close-modal" @click="$emit(_constants.modalClose.info)">&#10006;</button>
            </slot>
          </div>

          <div class="vp-section mb-0" v-html="_componentsDataStore.informationModal.modalInfo"/>
        </div>
      </div>
    </div>
  </transition>
  `;

  Vue.component("information-modal", {
    template: modalTemplate
  });
};



