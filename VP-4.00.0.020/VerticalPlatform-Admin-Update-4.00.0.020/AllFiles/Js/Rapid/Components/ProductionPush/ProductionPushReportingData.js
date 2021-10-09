
var productionPushReportingData = function () {
  let DataTemplate = `
  <div class="vp-col col-fill p-0 production-push-report">
    <div class="table-checkbox border-left">
      <label class="header-background" v-html="task.taskName"/>
      <label>{{task.taskCount}}</label>
      <div v-if="task.taskCount > 0">
        <input type="checkbox" 
        v-model="isChecked" 
        @change="checkBoxClick()" 
        v-if="task.taskId == 0 || task.taskStatus == _constants.status.PENDING"
        :disabled="jobStatus == _constants.status.INPROGRESS">
        <label class="no-border" v-if="task.taskId != 0 &&
        task.taskStatus != _constants.status.FINISHED &&
        task.taskStatus != _constants.status.PENDING">
          Awaiting Report
        </label>
        <input type="button"
          v-if="task.taskStatus == _constants.status.FINISHED"
          :disabled="jobStatus == _constants.status.INPROGRESS"
          @click="downloadReport()"
          title="Click to download report" 
          style="background-image: url(../../Js/Rapid/Assets/Images/download.png);" class="center-button download-button btn">
      </div>
    </div>
  </div>
`;

  Vue.component('production-push-reporting-data', {
    template: DataTemplate,
    mixins: [_jobApiMixin],
    props: {
      taskProp:{
        required: true,
        type: Object
      },
      jobStatusProp:{
        required: true,
        type: Number
      },
      checkBoxFunc:{
        required:true,
        type: Function
      }
    },
    data() {
      return {
        task: this.taskProp,
        jobStatus: this.jobStatusProp,
        isChecked: false
      };
    },
    watch:{
      taskProp(){
        this.task = this.taskProp;
      },
      jobStatusProp(){
        this.jobStatus = this.jobStatusProp;
      }
    },
    created(){
      this.setStoreReportCheckBox(false);
    },
    updated(){
      this.isChecked = this.getStoreReportCheckBox();
      this.checkBoxClick();
    },
    methods: {
      checkBoxClick(){
        this.setStoreReportCheckBox(this.isChecked);

        if(this.isChecked && this.task.taskId > 0){
          this.checkBoxFunc(this.task, this.task.taskType);
        } else {
          this.checkBoxFunc(this.isChecked, this.task.taskType);
        }
      },

      async downloadReport(){
        this.DownloadReports(this.task.taskId);
      },

      setStoreReportCheckBox(value){
        if(this.task.taskType == _constants.taskType.PRODUCTIONPUSH_ERROR_REPORT){
          let data = _componentsDataStore.productionPushTab[this.task.jobId].production.reports[this.task.taskType];
          _componentsDataStore.productionPushTab[this.task.jobId].production.reports[this.task.taskType] = {
            ...data,
            reportCheckBox:value
          };
        }else{
          let data = _componentsDataStore.productionPushTab[this.task.jobId].reports[this.task.taskType];
          _componentsDataStore.productionPushTab[this.task.jobId].reports[this.task.taskType] = {
            ...data,
            reportCheckBox:value
          };
        }
      },

      getStoreReportCheckBox(){
        if(this.task.taskType == _constants.taskType.PRODUCTIONPUSH_ERROR_REPORT){
          return _componentsDataStore.productionPushTab[this.task.jobId].production.reports[this.task.taskType]?.reportCheckBox;
        }else{
          return _componentsDataStore.productionPushTab[this.task.jobId].reports[this.task.taskType]?.reportCheckBox;
        }
      }
    }
  });
};
