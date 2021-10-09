
var reportsTabComponent = function () {

    let TabTemplate = `
    <div>
      <div class="vp-rapid-container">
        <div id="test1" class="no-data-placeholder" v-if="reportJobs.length == 0">
          {{loadingMessage}}<spinner v-if="showSpinner"/>
        </div>
        <div class="vp-section active" v-if="activeJobs.length > 0">
          <h2 class="title">Processing</h2>
          <draggable :list="activeJobs" :disabled="true">
            <reports-tile :jobProp="job" 
            class="block"
            v-for="job in activeJobs"/>
          </draggable>
        </div>
        <div class="vp-section" v-if="queueJobs.length > 0">
          <h2 class="title">Scheduled</h2>
          <draggable :list="queueJobs" @change="changed($event, queueJobs)">
            <reports-tile :jobProp="job" class="animate" v-for="job in queueJobs"/>
          </draggable>
        </div>
        <div class="vp-section" v-if="pendingJobs.length > 0">
          <h2 class="title">Unscheduled</h2>
          <draggable :list="pendingJobs" :disabled="true">
            <reports-tile 
            :jobProp="job" 
            :getNextQueueNumFunc="getQueueInNext" 
            v-for="job in pendingJobs"/>
          </draggable>
        </div>
        <div class="vp-section error" v-if="errorJobs.length > 0">
          <h2 class="title">Error</h2>
          <draggable :list="errorJobs" :disabled="true">
            <reports-tile :jobProp="job" v-for="job in errorJobs"/>
          </draggable>
        </div>
      </div>
    </div>
    `;

  Vue.component('reports-tab', {
    template: TabTemplate,
    mixins: [_jobApiMixin, _taskApiMixin], 
    data() {
      return {
        activeJobs: [],
        queueJobs: [],
        pendingJobs: [],
        errorJobs: []
      };
    },
    created: async function(){
      this.showSpinner = true;
      this.loadingMessage = "";
      await this.GetReportJobsAndTasks();
    },
    computed:{
      reportJobs() {
        return _apiDataStore.reportJobs;
      }
    },
    watch: {
      reportJobs() {
        if (_apiDataStore.reportJobs.length === 0) {
          this.loadingMessage = "No Jobs in Reporting State";
          this.showSpinner = false;
        }

        this.sortTabJobs();
      }
    },
    methods: {
      async changed(evt,jobs) {
        var index = evt.moved.newIndex;
        var job = evt.moved.element;
        var processOrder = jobs[index - 1] ? 
        jobs[index - 1].jobOrder + 1 : 
        jobs[index + 1].jobOrder - 1;

        job.jobOrder = processOrder;
        await this.UpdateJobOrder(job);
        await this.GetReportJobsAndTasks();
      },
      
      sortTabJobs() {
        var activeJobs = [];
        var queueJobs = [];
        var pendingJobs = [];
        var errorJobs = [];
        
        _apiDataStore.reportJobs.forEach(job => {
          if(job.jobIsError){
            errorJobs.push(job);
          } 
          else if(job.jobStatus === _constants.status.INPROGRESS){
            activeJobs.push(job);
          }
          else if(job.jobStatus === _constants.status.PENDING){
            pendingJobs.push(job);
          }
          else{
            queueJobs.push(job);
          }
        });

        this.activeJobs = activeJobs;
        this.queueJobs = queueJobs;
        this.pendingJobs = pendingJobs;
        this.errorJobs = errorJobs;
      },

      getQueueInNext(){
        if(this.queueJobs.length > 0){
          return this.queueJobs[this.queueJobs.length - 1].jobOrder + 1;
        }else{
          return 0;
        }
      }
    }
  });
};

