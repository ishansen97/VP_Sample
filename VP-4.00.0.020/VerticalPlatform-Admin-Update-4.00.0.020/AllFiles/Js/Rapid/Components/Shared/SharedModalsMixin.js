var sharedModalMixin = function() {
  return {
    methods: {
      showInfoModal(title, info) {
        _componentsDataStore.informationModal.show = true;
        _componentsDataStore.informationModal.modalTitle = title;
        _componentsDataStore.informationModal.modalInfo = info;
      },

      showConfirmModal(info, func) {
        _componentsDataStore.confirmationModal.show = true;
        _componentsDataStore.confirmationModal.modalInfo = info;
        _componentsDataStore.confirmationModal.confirmFunction = func;
      }
      
    }
  };
  
}