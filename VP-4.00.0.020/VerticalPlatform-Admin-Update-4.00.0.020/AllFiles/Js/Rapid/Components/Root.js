var root = function () {
  let rootTemplate = `
  <div>
    <div class="vp-row mt-3 rapid-actions-bar" 
    v-if="_componentsDataStore.permission(_constants.permissions.ADD)">
      <div class="vp-col text-right">
        <button type="button" 
        title="Add new job to rapid" 
        class="btn" id="show-modal" @click="showJobModal = true">
          Add Job
        </button>
      </div>
    </div>
    <!-- use the modal component, pass in the prop -->
    <add-job-modal v-if="showJobModal" @addJobClose="showJobModal = false"/>
    <information-modal 
      v-if="_componentsDataStore.informationModal.show" 
      @infoClose="_componentsDataStore.informationModal.show = false"/>

    <confirmation-modal 
      v-if="_componentsDataStore.confirmationModal.show" 
      @confirmClose="_componentsDataStore.confirmationModal.show = false"/>

    <tabs :class="{'mt-3': !_componentsDataStore.permission(_constants.permissions.ADD)}">
      <tab name="Pre-processing" :selected="true">
        <reports-tab></reports-tab>
      </tab>
      <tab name="Production Push">
        <production-push-tab></production-push-tab>
      </tab>
      <tab name="Clean Up">
        <clean-up-tab></clean-up-tab>
      </tab>
      <tab name="Completed">
        <completed-tab></completed-tab>
      </tab>
    </tabs>
  </div>
`;

  Vue.component('root', {
    template: rootTemplate,
    mixins: [_jobApiMixin],
    data() {
      return {
        showJobModal: false,
        autoUpdate: ''
      };
    },
    created() {
      (function(){
        _componentsDataStore.permission = new Function('perm',`
        if(perm == _constants.permissions.ADD){
          return ${CONFIG.userAdd};
        }
        if(perm == _constants.permissions.EDIT){
          return ${CONFIG.userEdit};
        }
        if(perm == _constants.permissions.DELETE){
          return ${CONFIG.userDelete};
        }
        return false;
        `);

      })();
      
      this.autoUpdate = setInterval(this.updateData, 20000);
    },
    methods:{
      updateData(){
        this.GetReportJobsAndTasks();
        this.GetProductionPushJobsAndTasks();
        this.GetCleanUpJobs();
        this.GetCompletedJobs();
      }      
    },
    beforeDestroy () {
      clearInterval(this.autoUpdate);
    }
  });
};