var cleanUpTabComponent = function () {
  let TabTemplate = `
  <div>
  <div class="vp-rapid-container">
    <div class="no-data-placeholder" v-if="cleanUpJobs.length == 0">
      {{loadingMessage}}<spinner v-if="showSpinner"/>
    </div>
    <div class="vp-section active" v-if="activeJobs.length > 0" >
      <h2 class="title">Processing</h2>
      <draggable :list="activeJobs" :disabled="true">
        <clean-up-tile 
          class="block"
          :jobProp="job" 
          v-for="job in activeJobs"/>
      </draggable>
    </div>
    <div class="vp-section" v-if="queueJobs.length > 0">
      <h2 class="title">Scheduled</h2>
      <draggable :list="queueJobs" :disabled="true">
        <clean-up-tile 
          :jobProp="job" 
          v-for="job in queueJobs"/>        
      </draggable>
    </div>
  </div>
</div>
`;

  Vue.component('clean-up-tab', {
    template: TabTemplate,
    mixins: [_jobApiMixin, _taskApiMixin],
    data() {
      return {
        activeJobs: [],
        queueJobs: []
      };
    },
    created: async function () {
      this.showSpinner = true;
      this.loadingMessage = "";
      await this.GetCleanUpJobs();
    },
    computed: {
      cleanUpJobs() {
        return _apiDataStore.cleanUpJobs;
      }
    },
    watch: {
      cleanUpJobs() {
        if (_apiDataStore.cleanUpJobs.length === 0) {
          this.loadingMessage = "No Jobs in Clean Up State";
          this.showSpinner = false;
        }

        this.sortTabJobs();
      }
    },
    methods: {
      sortTabJobs() {
        this.activeJobs = [];
        this.queueJobs = [];

        _apiDataStore.cleanUpJobs.forEach(job => {
          if (job.jobStatus == _constants.status.INPROGRESS) {
            this.activeJobs.push(job);
          } else {
            this.queueJobs.push(job);
          }
        });
      }
    }
  });
};
