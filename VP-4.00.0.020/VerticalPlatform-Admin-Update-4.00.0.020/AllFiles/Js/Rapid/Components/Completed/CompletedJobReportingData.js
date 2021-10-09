var completedJobReportingData = function () {
  let DataTemplate = `
  <div class="vp-col col-fill p-0">
    <div class="table-checkbox border-left completed">
      <label class="header-background" v-html="task.taskName"/>
      <label>{{task.taskCount}}</label>
      <div>
        <div v-if="task.taskCount > 0" class="action">
          <label class="no-border" v-if="task.taskStatus != _constants.status.FINISHED">
            Awaiting Report
          </label>
          <input type="button"
            v-if="task.taskStatus == _constants.status.FINISHED"
            @click="downloadReport()"
            title="Click to download report" 
            style="background-image: url(../../Js/Rapid/Assets/Images/download.png);" class="center-button download-button btn">
        </div>
      </div>
    </div>
  </div>
`;

  Vue.component('completed-job-reporting-data', {
    template: DataTemplate,
    mixins: [_jobApiMixin],
    props: {
      taskProp:{
        required: true,
        type: Object
      }
    },
    data() {
      return {
        task: this.taskProp
      };
    },
    methods: {
      async downloadReport(){
        this.DownloadReports(this.task.taskId);
      }
    }
  });
};
