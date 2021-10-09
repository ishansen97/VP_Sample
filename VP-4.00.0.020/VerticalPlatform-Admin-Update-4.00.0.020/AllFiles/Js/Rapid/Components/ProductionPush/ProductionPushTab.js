var productionPushTabComponent = function () {
  let TabTemplate = `
  <div>
  <div class="vp-rapid-container">
    <div class="no-data-placeholder" v-if="productionPushJobs.length == 0">
      {{loadingMessage}}<spinner v-if="showSpinner"/>
    </div>
    <div class="vp-section active" v-if="activeJobs.length > 0" :key="renderActive">
      <h2 class="title">Processing</h2>
      <draggable :list="activeJobs" :disabled="true">
        <production-push-tile 
        class="block"
        :jobProp="job"
        v-for="job in activeJobs"/>
      </draggable>
    </div>
    <div class="vp-section highlight" v-if="queueJobs.length > 0" :key="renderQueue">
      <h2 class="title">Scheduled</h2>
      <draggable :list="queueJobs" @change="changed($event, queueJobs)" >
        <production-push-tile 
        class="animate"
        :jobProp="job" 
        v-for="job in queueJobs"/>
      </draggable>
    </div>
    <div class="vp-section" v-if="pendingJobs.length > 0" :key="renderPending">
      <h2 class="title">Unscheduled</h2>
      <draggable :list="pendingJobs" :disabled="true">
        <production-push-tile 
        :jobProp="job"
        :getNextQueueNumFunc="getQueueInNext" 
        v-for="job in pendingJobs"/>
      </draggable>
    </div>
  </div>
</div>
`;

  Vue.component('production-push-tab', {
    template: TabTemplate,
    mixins: [_jobApiMixin, _taskApiMixin], 
    data() {
      return {
        activeJobs: [],
        queueJobs: [],
        pendingJobs: [],
        renderActive:0,
        renderQueue:0,
        renderPending:0,
        changedOnSort: false
      };
    },
    created: async function () {
      this.showSpinner = true;
      this.loadingMessage = "";
      await this.GetProductionPushJobsAndTasks();
    },
    computed:{
      productionPushJobs() {
        return _apiDataStore.productionPushJobs;
      }
    },
    watch: {
      productionPushJobs() {
        if (_apiDataStore.productionPushJobs.length === 0) {
          this.loadingMessage = "No Jobs in Production Push State";
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
        this.changedOnSort = true;
        this.renderQueue = this.getUniqueKey();
        await this.UpdateJobOrder(job);
        await this.GetProductionPushJobsAndTasks();
      },

      sortTabJobs(){
        var oldActive = this.activeJobs;
        var oldQueue = this.queueJobs;
        var oldPending = this.pendingJobs;
        var activeJobs = [];
        var pendingJobs = [];
        var queueJobs = [];

        _apiDataStore.productionPushJobs.forEach(job => {
          if(job.jobStatus === _constants.status.INPROGRESS){
            this.addSortedByModified(activeJobs, job);
          } 
          else if(job.jobStatus === _constants.status.PENDING){
            this.addSortedByModified(pendingJobs, job);
          }
          else{
            queueJobs.push(job);
          }
        });

        this.activeJobs = activeJobs;
        this.pendingJobs = pendingJobs;
        this.queueJobs = queueJobs;

        if(!this.changedOnSort){
          if(JSON.stringify(oldActive) !== JSON.stringify(activeJobs)){
            this.renderActive = this.getUniqueKey();
          }
          if(JSON.stringify(oldQueue) !== JSON.stringify(queueJobs)){
            this.renderQueue = this.getUniqueKey();
          } 
          if(JSON.stringify(oldPending) !== JSON.stringify(pendingJobs)){
            this.renderPending = this.getUniqueKey();
          }
        }else{
          this.changedOnSort = false;
        }
      },

      getUniqueKey(){
        var newKey = 0;
        do {
         newKey = Math.floor(Math.random() * 10000) + 1;
        } while (!(newKey != this.renderActive &&
          newKey != this.renderQueue &&
          newKey != this.renderPending));
        return newKey;
      },

      addSortedByModified(arr, job){
        let index = 0;
        var length = arr.length;
        for (index; index < length; index++) {
          if(arr[index].jobModifiedTime < job.jobModifiedTime){
            break;
          }
        }
        arr.splice(index, 0, job);
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
