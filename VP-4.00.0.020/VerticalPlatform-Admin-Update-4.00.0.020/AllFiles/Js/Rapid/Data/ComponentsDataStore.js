var ComponentsDataStore = function () {
  return Vue.observable({
    productionPushTab: {},

    informationModal:{
      show: false,

      modalTitle: "No title",
      modalInfo: "No info"
    },

    confirmationModal:{
      show: false,

      modalTitle: "Confirmation",
      modalInfo: "No info"
    },

    permission:{}
  });
};
