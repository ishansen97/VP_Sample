var productionPushProductionData = function () {
  let DataTemplate = `
  <div class="vp-col col-fill p-0">
    <div class="table-checkbox border-left">
      <label class="header-background">{{task.taskName}}</label>
      <label v-if="(task.reportingCount == 0 || !productionCheckBoxVisibility) 
      && this.task.taskStatus !== _constants.status.FINISHED">
      {{ task.reportingCount == 0 ? '-' : '&nbsp;' }}
      </label>
      <div class="single-checkbox" v-if="productionCheckBoxVisibility" >
        <input type="checkbox"
        v-model="productionIsChecked" 
        @change="productionCheckBoxClick()"
        :disabled="(jobStatus == _constants.status.INPROGRESS || jobStatus == _constants.status.QUEUE)">
      </div>
      <div v-if="task.taskStatus == _constants.status.FINISHED">
        <label>
        {{task.taskCount}}
        </label>
        <div v-if="task.taskCount > 0">
          <input type="checkbox" 
          v-model="reportsIsChecked"
          @change="reportCheckBoxClick()" 
          v-if="reportTask.taskId == 0" 
		      :disabled="jobStatus == _constants.status.INPROGRESS" >
          <label class="no-border"v-if="reportTask.taskId != 0 &&
          reportTask.taskStatus != _constants.status.FINISHED">
          Awaiting Report
          </label>
          <input type="button" class="center-button download-button btn"
          v-if="reportTask.taskStatus == _constants.status.FINISHED"
          :disabled="jobStatus == _constants.status.INPROGRESS"
          @click="downloadReport()"
          title="Click to download report" 
          style="background-image: url(../../Js/Rapid/Assets/Images/download.png);" >
        </div>
      </div>
    </div>
  </div>
`;

  Vue.component('production-push-production-data', {
    template: DataTemplate,
    mixins: [_jobApiMixin, _taskApiMixin],
    props: {
      taskProp: {
        required: true,
        type: Object
      },
      reportTaskProp: { 
        required: true,
        type: Object
      },
      jobStatusProp:{
        required: true,
        type: Number
      },
      productionCheckBoxFunc: {
        required: true,
        type: Function
      },
      reportCheckBoxFunc: {
        required: true,
        type: Function
      }
    },
    data() {
      return {
        task: this.taskProp,
        reportTask: this.reportTaskProp,
        jobStatus: this.jobStatusProp,
        productionIsChecked: false,
        reportsIsChecked: false
      };
    },
    created: function(){
      this.setStoreProductionCheckBox(false);
      this.setStoreReportCheckBox(false);

      this.checkboxRestore();
    },
    computed:{
      productionCheckBoxVisibility: function (){
        if(this.task.reportingCount > 0 && this.task.taskStatus !== _constants.status.FINISHED){
          if(this.jobStatus !== _constants.status.PENDING){
            return true;
          }
          return _componentsDataStore.permission(_constants.permissions.ADD);
        }
      }
    },
    watch:{
      taskProp(){
        this.task = this.taskProp;
        this.checkboxRestore();
      },
      reportTaskProp(){
        this.reportTask = this.reportTaskProp;
        this.checkboxRestore();
      },
      jobStatusProp(){
        this.jobStatus = this.jobStatusProp;
      }
    },
    updated(){
      this.productionIsChecked = this.getStoreProductionCheckBox();
      this.reportsIsChecked = this.getStoreReportCheckBox();


      if(this.jobStatus == _constants.status.PENDING){
        this.productionCheckBoxClick();
      }
      this.reportCheckBoxClick();
    },
    methods: {
      productionCheckBoxClick(){
        this.setStoreProductionCheckBox(this.productionIsChecked);

        if(this.productionIsChecked && this.task.taskId > 0){
          this.productionCheckBoxFunc(this.task, this.task.taskType);
        } else {
          this.productionCheckBoxFunc(this.productionIsChecked, this.task.taskType);
        }
      },

      checkboxRestore(){
        if(this.task.taskId > 0 && this.jobStatus != _constants.status.PENDING
          && this.task.taskStatus != _constants.status.PENDING){
          this.productionIsChecked = true;
          this.setStoreProductionCheckBox(this.productionIsChecked);
        }
      },

      reportCheckBoxClick(){
        this.setStoreReportCheckBox(this.reportsIsChecked);

        if(this.reportsIsChecked && this.reportTask.taskId > 0){
          this.reportCheckBoxFunc(this.reportTask,this.reportTask.taskType);
        } else {
          this.reportCheckBoxFunc(this.reportsIsChecked, this.reportTask.taskType);
        }
      },

      async downloadReport() {
        this.DownloadReports(this.reportTask.taskId);
      },

      setStoreReportCheckBox(value){
        var data = _componentsDataStore.productionPushTab[this.task.jobId].production.reports[this.task.taskType];
        _componentsDataStore.productionPushTab[this.task.jobId].production.reports[this.task.taskType] = {
          ...data,
          reportCheckBox: value
        };
      },

      getStoreReportCheckBox(){
        return _componentsDataStore.productionPushTab[this.task.jobId].production.reports[this.task.taskType]?.reportCheckBox;
      },

      setStoreProductionCheckBox(value){
        var data = _componentsDataStore.productionPushTab[this.task.jobId].production.production[this.task.taskType];
        _componentsDataStore.productionPushTab[this.task.jobId].production.production[this.task.taskType] = {
          ...data,
          productionCheckBox: value
        };
      },

      getStoreProductionCheckBox(){
        return _componentsDataStore.productionPushTab[this.task.jobId].production.production[this.task.taskType]?.productionCheckBox;
      }
    }
  });
};
