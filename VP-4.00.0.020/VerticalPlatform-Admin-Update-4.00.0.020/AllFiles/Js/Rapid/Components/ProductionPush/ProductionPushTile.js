var productionPushTile = function () {
  let dataTemplate = `
    <div class="card" >
        <div class="header">
          <div class="vp-row">
            <div class="vp-col col-4 truncate">
              <b>Site: {{job.jobSiteName}}</b>
            </div>
            <div class="vp-col col-fill">
              <b>Job ID: {{job.jobId}}</b>
            </div>
            <div class="vp-col col-auto">
              <b>InProgress:</b> {{message.active}}
              <b>&nbsp;&nbsp;Queue:</b> {{message.queue}}
              &nbsp;&nbsp;
              <img @click="viewEmails()" 
                title="Click to view subscribed email addresses" 
                class="mail-icon" src="../../Js/Rapid/Assets/Images/mail.png">
            </div>
          </div>
        </div>
        <div class="body">
          <div class="vp-row">
            <div class="vp-col col-4">
              <div><small class="tiny-label">Vendor:</div>
              {{job.jobVendorId}} - {{job.jobVendorName}}
            </div>
            <div class="vp-col col-4">
              <div><small class="tiny-label">Data File:</small></div>
              <div class="truncate"  v-bind:title="job.jobDataFileName">
                {{job.jobDataFileName}}
              </div>
            </div>
            <div class="vp-col col-fill text-right">
              <button title="Unschedule the job" type="button" 
                v-if="_componentsDataStore.permission(_constants.permissions.EDIT)"
                :disabled="(job.jobStatus != _constants.status.QUEUE)" 
                @click="showConfirmModal(confirmModalText('unschedule'),unschedule)" 
                style="margin-left: auto;" class="unschedule-btn btn">
                Unschedule
              </button>
              <button title="Cleanup the job and generate all the reports" type="button" 
                v-if="_componentsDataStore.permission(_constants.permissions.ADD)" 
                :disabled="(job.jobStatus != _constants.status.PENDING)" 
                @click="showConfirmModal(confirmModalText('cleanup'),runCleanUp)" 
                style="margin-left: auto;" class="btn">
                Run Cleanup
              </button>
            </div>
          </div>
          <div class="vp-row">
            <div class="vp-col col-5">
              <div class="vp-row">
                <div class="vp-col col-fill">
                  <div class="sub-header">Pre-processing</div>
                </div>
              </div>
              <div class="vp-row pre-processing-report">
                <div class="vp-col col-12">
                  <div class="vp-row m-0">
                    <production-push-reporting-data 
                      :taskProp="reportingInsertTask" 
                      :jobStatusProp="job.jobStatus" 
                      :checkBoxFunc="RReportsRequest"/>
                    <production-push-reporting-data 
                      :taskProp="reportingUpdateTask" 
                      :jobStatusProp="job.jobStatus" 
                      :checkBoxFunc="RReportsRequest"/>
                    <production-push-reporting-data 
                      :taskProp="reportingDeleteTask" 
                      :jobStatusProp="job.jobStatus" 
                      :checkBoxFunc="RReportsRequest"/>
                    <production-push-reporting-data 
                      :taskProp="reportingErrorTask" 
                      :jobStatusProp="job.jobStatus" 
                      :checkBoxFunc="RReportsRequest"/>
                  </div>
                </div>
              </div>
              <div class="vp-row m-0 more-reports-header" @click="expandReportsClick()">
                <div class="vp-col col-3 p-0">
                  <div>
                    <div>
                      More Reports
                    </div>
                  </div>
                </div>
                <div class=" vp-col col-9 article_srh_btn report-search-btn" v-bind:class="{ hide_icon: expandReports }"/>
              </div>
              <div class="vp-row pre-processing-report">
                <div class="vp-col col-12">
                  <div class="vp-row m-0 report-anim" v-bind:class="{ expand: expandReports }">
                    <production-push-reporting-data 
                      :taskProp="reportingReEnablesTask" 
                      :jobStatusProp="job.jobStatus" 
                      :checkBoxFunc="RReportsRequest"/>
                    <production-push-reporting-data 
                      :taskProp="reportingIgnoredSearchOptionsTask" 
                      :jobStatusProp="job.jobStatus" 
                      :checkBoxFunc="RReportsRequest"/>
                    <production-push-reporting-data 
                      :taskProp="reportingIgnoreInRapidTask" 
                      :jobStatusProp="job.jobStatus" 
                      :checkBoxFunc="RReportsRequest"/>
                  </div>
                </div>
              </div>
              <div class="vp-row m-0">
                <div class="vp-col col-12 p-0">
                  <div class="table-checkbox m-0 no-top-border border-left" v-if="job.jobStatus !== _constants.status.INPROGRESS">
                    <button type="button"
                      @click="showConfirmModal(confirmModalText('requestreportingreports'),requestReportingReports)" 
                      :disabled="!rReportsButtonActive" 
                      class="btn mt-3 mb-3">Request Reports</button>
                  </div>
                </div>
              </div>
            </div>
            <div class="vp-col col-fill">
              <div class="vp-row">
                <div class="vp-col col-12">
                  <div class="sub-header">Production Push</div>
                </div>
              </div>
              <div class="vp-row">
                <div class="vp-col col-12">
                  <div class="vp-row m-0">
                    <production-push-production-data 
                      :taskProp="insertTask" 
                      :reportTaskProp="productionInsertReportTask" 
                      :jobStatusProp="job.jobStatus" 
                      :productionCheckBoxFunc="PPRequest" 
                      :reportCheckBoxFunc="PPReportsRequest"/>
                    <production-push-production-data 
                      :taskProp="updateTask" 
                      :reportTaskProp="productionUpdateReportTask" 
                      :jobStatusProp="job.jobStatus" 
                      :productionCheckBoxFunc="PPRequest" 
                      :reportCheckBoxFunc="PPReportsRequest"/>
                    <production-push-production-data 
                      :taskProp="deleteTask" 
                      :reportTaskProp="productionDeleteReportTask" 
                      :jobStatusProp="job.jobStatus" 
                      :productionCheckBoxFunc="PPRequest" 
                      :reportCheckBoxFunc="PPReportsRequest"/>
                    <production-push-reporting-data 
                      :taskProp="productionErrorReportTask" 
                      :jobStatusProp="job.jobStatus" 
                      :checkBoxFunc="PPReportsRequest"/>
                    <div class="vp-col col-fill p-0">
                      <div class="table-checkbox p-3">
                        <div class="vp-row">
                          <div class="vp-col col-12 production-push-action">
                            <input type="button" 
                              v-if="_componentsDataStore.permission(_constants.permissions.ADD)"
                              :disabled="!ppRunButtonActive" 
                              @click="showConfirmModal(confirmModalText('run'),runProductionPush)" 
                              class="btn mt-3 mb-3" value ="Run"/>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="vp-row m-0">
                <div class="vp-col col-12 p-0">
                  <div class="table-checkbox no-top-border border-left" v-if="job.jobStatus !== _constants.status.INPROGRESS">
                    <button type="button"
                    @click="showConfirmModal(confirmModalText('requestproductionreports'),requestProductionReports)" 
                    :disabled="!ppReportsButtonActive"  
                    class="btn mt-3 mb-3">
                    Request Reports
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="vp-row">
            <div class="vp-col col-4 mt-5px vertical-center">
              <small class="tiny-label mr-5px">Unchanged Product Count:</small>
              {{reportingTask.taskUnchangedProductCount}}
            </div>
          </div>
        </div>
    </div>
`;

  Vue.component('production-push-tile', {
    template: dataTemplate,
    mixins: [_jobApiMixin, _taskApiMixin, _sharedModalMixin],
    props: {
      jobProp: {
        required: true,
        type: _models.JobModel()
      },
      getNextQueueNumFunc: {
        type: Function
      }
    },
    data() {
      return {
        job: this.jobProp,

        expandReports: false,

        rReportsButtonActive:false,
        ppRunButtonActive:false,
        ppReportsButtonActive:false,

        rReportsData:{},
        ppPendingTaskData: {},
        ppReportsData:{},
        ppErrorCount: 0,

        defaultMessages: {
          active: "N/A",
          queue: "N/A"
        },
        message: {},
        reportRequestMessage: `Your report request is being processed right now, 
        all users subscribed to this job will receive a notification email once the report is ready to download.`,

        reportingTask: new _models.TaskModel(),

        reportingInsertTask:  {..._models.TaskModel(),
          taskName:'Insert',
          taskType: _constants.taskType.REPORTING_INSERT_REPORT,
          jobId: this.jobProp.jobId,
          taskCount: 0
        },
        reportingUpdateTask:  {..._models.TaskModel(),
          taskName:'Update',
          taskType: _constants.taskType.REPORTING_UPDATE_REPORT,
          jobId: this.jobProp.jobId,
          taskCount: 0
        },
        reportingDeleteTask:  {..._models.TaskModel(),
          taskName:'Delete',
          taskType: _constants.taskType.REPORTING_DELETE_REPORT,
          jobId: this.jobProp.jobId,
          taskCount: 0
        },
        reportingErrorTask:  {..._models.TaskModel(),
          taskName:'Error',
          taskType: _constants.taskType.REPORTING_ERROR_REPORT,
          jobId: this.jobProp.jobId,
          taskCount: 0
        },
        reportingReEnablesTask:  {..._models.TaskModel(),
          taskName:'Re-enables <br/><br/>',
          taskType: _constants.taskType.REPORTING_REENABLED_REPORT,
          jobId: this.jobProp.jobId,
          taskCount: 0
        },
        reportingIgnoreInRapidTask:  {..._models.TaskModel(),
          taskName:'Ignored in Rapid <br/><br/>',
          taskType: _constants.taskType.REPORTING_IGNOREDINRAPID_REPORT,
          jobId: this.jobProp.jobId,
          taskCount: 0
        },
        reportingIgnoredSearchOptionsTask:  {..._models.TaskModel(),
          taskName:'Ignored Search Options',
          taskType: _constants.taskType.REPORTING_IGNOREDSEARCHOPTION_REPORT,
          jobId: this.jobProp.jobId,
          taskCount: 0
        },
        insertTask: {..._models.TaskModel(),
          taskName:'Insert',
          taskType: _constants.taskType.INSERT,
          jobId: this.jobProp.jobId,
          taskCount: 0
        },
        updateTask: {..._models.TaskModel(),
          taskName:'Update',
          taskType: _constants.taskType.UPDATE,
          jobId: this.jobProp.jobId,
          taskCount: 0
        },
        deleteTask: {..._models.TaskModel(),
          taskName:'Delete',
          taskType: _constants.taskType.DELETE,
          jobId: this.jobProp.jobId,
          taskCount: 0
        },
        productionInsertReportTask:{..._models.TaskModel(),
          taskType: _constants.taskType.PRODUCTIONPUSH_INSERT_REPORT
        },
        productionUpdateReportTask:{..._models.TaskModel(),
          taskType: _constants.taskType.PRODUCTIONPUSH_UPDATE_REPORT
        },
        productionDeleteReportTask:{..._models.TaskModel(),
          taskType: _constants.taskType.PRODUCTIONPUSH_DELETE_REPORT
        },
        productionErrorReportTask: {..._models.TaskModel(),
          taskName:'Error',
          taskType: _constants.taskType.PRODUCTIONPUSH_ERROR_REPORT,
          jobId: this.jobProp.jobId,
          taskCount: 0
        }

      };
    },
    watch:{
      jobProp: {
        immediate: true,
        handler() {
          this.job = this.jobProp;
          this.filterTasks();
        }
      }
    },
    created(){
      if(this.job.jobStatus !== _constants.status.INPROGRESS &&
        _componentsDataStore.productionPushTab[this.job.jobId]?.expandReports){
        this.expandReports = true
      }

      _componentsDataStore.productionPushTab[this.job.jobId] = {
        reports: {},
        production: {
          reports: {},
          production: {}
        },
        expandReports: this.expandReports
      };
    },
    methods: {
      filterTasks(){
        this.reSetDefaults();
        for(var task of this.job.jobTasks){
          if(task.taskStatus == _constants.status.INPROGRESS){
            if(this.message.active != this.defaultMessages.active){
              this.message.active = this.message.active.concat(", ");
            } else {
              this.message.active = " ";
            }
            this.message.active = this.message.active.concat(_constants.GetTaskTypeString(task.taskType));
          }
          if(task.taskStatus == _constants.status.QUEUE){
            if(this.message.queue != this.defaultMessages.queue){
              this.message.queue = this.message.queue.concat(", ");
            } else {
              this.message.queue = " "
            }
            this.message.queue = this.message.queue.concat(_constants.GetTaskTypeString(task.taskType));
          }
          
          if(task.taskType == _constants.taskType.REPORTS){
            this.reportingInsertTask = { ...this.reportingInsertTask,
              taskCount: task.taskInsertedRecords
            }
            this.reportingUpdateTask = { ...this.reportingUpdateTask,
              taskCount: task.taskUpdatedRecords
            }
            this.reportingDeleteTask = { ...this.reportingDeleteTask,
              taskCount: task.taskDeletedRecords
            }
            this.reportingErrorTask = { ...this.reportingErrorTask,
              taskCount: task.taskErrorRecords
            }
            this.reportingReEnablesTask = { ...this.reportingReEnablesTask,
              taskCount: task.taskReEnabledProductCount
            }
            this.reportingIgnoreInRapidTask = { ...this.reportingIgnoreInRapidTask,
              taskCount: task.taskIgnoredInRapidProductCount
            }
            this.reportingIgnoredSearchOptionsTask = { ...this.reportingIgnoredSearchOptionsTask,
              taskCount: task.taskIgnoredSearchOptionProductCount
            }

            this.insertTask = {...this.insertTask,
              reportingCount: task.taskInsertedRecords
            }
            this.updateTask = {...this.updateTask,
              reportingCount: task.taskUpdatedRecords
            }
            this.deleteTask = {...this.deleteTask,
              reportingCount: task.taskDeletedRecords
            }

            this.reportingTask = task;
          }

          if(task.taskType == _constants.taskType.REPORTING_INSERT_REPORT){
            this.reportingInsertTask = this.updateTaskData(this.reportingInsertTask,task);
          }
          if(task.taskType == _constants.taskType.REPORTING_UPDATE_REPORT){
            this.reportingUpdateTask = this.updateTaskData(this.reportingUpdateTask,task);
          }
          if(task.taskType == _constants.taskType.REPORTING_DELETE_REPORT){
            this.reportingDeleteTask = this.updateTaskData(this.reportingDeleteTask,task);
          }
          if(task.taskType == _constants.taskType.REPORTING_ERROR_REPORT){
            this.reportingErrorTask = this.updateTaskData(this.reportingErrorTask,task);
          }
          if(task.taskType == _constants.taskType.REPORTING_REENABLED_REPORT){
            this.reportingReEnablesTask = this.updateTaskData(this.reportingReEnablesTask,task);
          }
          if(task.taskType == _constants.taskType.REPORTING_IGNOREDINRAPID_REPORT){
            this.reportingIgnoreInRapidTask = this.updateTaskData(this.reportingIgnoreInRapidTask,task);
          }
          if(task.taskType == _constants.taskType.REPORTING_IGNOREDSEARCHOPTION_REPORT){
            this.reportingIgnoredSearchOptionsTask = this.updateTaskData(this.reportingIgnoredSearchOptionsTask,task);
          }
          
          if(task.taskType == _constants.taskType.INSERT){
            this.insertTask = this.updateTaskData(this.insertTask,task);
            this.insertTask.taskCount = task.taskInsertedRecords;
            this.ppErrorCount += task.taskErrorRecords;
          }
          if(task.taskType == _constants.taskType.UPDATE){
            this.updateTask = this.updateTaskData(this.updateTask,task);
            this.updateTask.taskCount = task.taskUpdatedRecords;
            this.ppErrorCount += task.taskErrorRecords;
          }
          if(task.taskType == _constants.taskType.DELETE){
            this.deleteTask = this.updateTaskData(this.deleteTask,task);
            this.deleteTask.taskCount = task.taskDeletedRecords;
            this.ppErrorCount += task.taskErrorRecords;
          }

          if(task.taskType == _constants.taskType.PRODUCTIONPUSH_INSERT_REPORT){
            this.productionInsertReportTask = this.updateTaskData(this.productionInsertReportTask,task);
          }
          if(task.taskType == _constants.taskType.PRODUCTIONPUSH_UPDATE_REPORT){
            this.productionUpdateReportTask = this.updateTaskData(this.productionUpdateReportTask,task);
          }
          if(task.taskType == _constants.taskType.PRODUCTIONPUSH_DELETE_REPORT){
            this.productionDeleteReportTask = this.updateTaskData(this.productionDeleteReportTask,task);
          }
          if(task.taskType == _constants.taskType.PRODUCTIONPUSH_ERROR_REPORT){
            this.productionErrorReportTask = this.updateTaskData(this.productionErrorReportTask,task);
            this.productionErrorReportTask.taskCount = task.taskErrorRecords;
          }

        };

        if(this.productionErrorReportTask.taskId != 0 
          && this.productionErrorReportTask.taskCount != this.ppErrorCount 
          && this.productionErrorReportTask.taskStatus != _constants.status.QUEUE){
            this.productionErrorReportTask.taskStatus = _constants.status.PENDING;
        }
        this.productionErrorReportTask.taskCount = this.ppErrorCount;

      },
      updateTaskData(taskData, task){
        return taskData = {...taskData,
            taskId: task.taskId,
            taskStatus: task.taskStatus
        };
      },

      expandReportsClick(){
        this.expandReports = !this.expandReports
        _componentsDataStore.productionPushTab[this.job.jobId].expandReports =
          this.expandReports
      },

      reSetDefaults(){
        this.message = {...this.defaultMessages};
        this.rReportsButtonActive = false;
        this.ppRunButtonActive = false;
        this.ppReportsButtonActive = false;

        this.rReportsData = {};
        this.ppPendingTaskData =  {};
        this.ppReportsData = {};
        this.ppErrorCount =  0;
      },

      viewEmails(){
        var emails = this.job.jobEmails.toLowerCase().replace(/,|;/g, '</li><li>');
        var emailView = `<ul><li>${emails}</li></ul>`; 
        this.showInfoModal("Subscribed Email List", emailView);
      },

      PPRequest(task, taskType){
        if(task)
        {
          if(task.taskId == null){
            this.ppPendingTaskData[taskType] = taskType;
          }else{
            this.ppPendingTaskData[taskType] = task;
          }
          this.ppRunButtonActive = true;
        } 
        else {
          delete this.ppPendingTaskData[taskType];
          
          if(Object.keys(this.ppPendingTaskData).length > 0){
            this.ppRunButtonActive = true;
          }else{
            this.ppRunButtonActive = false;
          }
        }
      },

      PPReportsRequest(task, taskType){ 
        if(task)
        {
          if(task.taskId == null){
            this.ppReportsData[taskType] = taskType;
          }else{
            this.ppReportsData[taskType] = task;
          }
          this.ppReportsButtonActive = true;
        } 
        else {
          delete this.ppReportsData[taskType];

          if(Object.keys(this.ppReportsData).length > 0){
            this.ppReportsButtonActive = true;
          }else{
            this.ppReportsButtonActive = false;
          }
        }
      },

      RReportsRequest(task, taskType){ 
        if(task)
        {
          if(task.taskId == null){
            this.rReportsData[taskType] =  taskType;
          }else{
            this.rReportsData[taskType] = task;
          }
          this.rReportsButtonActive = true;
        } 
        else {
          delete this.rReportsData[taskType];

          if(Object.keys(this.rReportsData).length > 0){
              this.rReportsButtonActive = true;
          }else{
            this.rReportsButtonActive = false;
          }
        }
      },

      async addOrUpdateTasks(taskList, jobStatus){
        for(var task of Object.values(taskList)) {
          if(task.taskId != null && task.taskStatus != _constants.status.FINISHED){
            task.taskStatus = _constants.status.QUEUE;
            await this.UpdateTaskStatus(task);
          }else{
            await this.AddTask(this.job.jobId, task);
          }
        }

        if(jobStatus != null){
          this.job.jobStatus = jobStatus;
          await this.UpdateJobStatus(this.job);
        }
        
        await this.GetProductionPushJobsAndTasks();
      },

      async runProductionPush(){
        if(Object.keys(this.ppPendingTaskData).length > 0){
          var queueNext = this.getNextQueueNumFunc();
          if(queueNext > 0){
            this.job.jobOrder = queueNext;
            await this.UpdateJobOrder(this.job);
          }
          _componentsDataStore.productionPushTab[this.job.jobId].production.production = {};
          await this.UpdateJobEmails();
          await this.addOrUpdateTasks(this.ppPendingTaskData, _constants.status.QUEUE);
        }
      },

      async requestProductionReports(){
        _componentsDataStore.productionPushTab[this.job.jobId].production.reports = {};
        await this.UpdateJobEmails();
        await this.addOrUpdateTasks(this.ppReportsData);
        $.notify({ message: this.reportRequestMessage, type: 'info' });
      },

      async requestReportingReports(){
        _componentsDataStore.productionPushTab[this.job.jobId].reports = {};
        await this.UpdateJobEmails();
        await this.addOrUpdateTasks(this.rReportsData);
        $.notify({ message: this.reportRequestMessage, type: 'info' });
      },
      
      async runCleanUp(){
        await this.RunCleanUp(this.job.jobId);
        await this.GetProductionPushJobsAndTasks();
        await this.GetCleanUpJobs();
      },

      async UpdateJobEmails() {
        var existingEmails = this.job.jobEmails.split(/,|;/);
        var loggedInUser = CONFIG.currentUserEmail.trim().toLowerCase();
        var userAvailable = false;
        for (var i = 0; i < existingEmails.length; i++) {
          if (existingEmails[i].trim().toLowerCase() === loggedInUser) {
            userAvailable = true;
          }
        }

        if (!userAvailable) {
          this.job.jobEmails = this.job.jobEmails + "," + loggedInUser;
          await this.UpdateJob(this.job);
        }
      },

      async unschedule(){
        try {
          await this.UnscheduleJobAndTasks(this.job.jobId);
        } 
        finally {
          await this.GetProductionPushJobsAndTasks();
        }
      },
      
      confirmModalText(action){
        switch (action) {
          case "run":
            var info = `You are about to execute a Production Push 
              <br><div class="mt-5px">Job ID :<b> ${this.job.jobId}</b>
              <br>Vendor :<b> ${this.job.jobVendorId} - ${this.job.jobVendorName}</b>
              <br>Task :<b> ${this.getTasksText(this.ppPendingTaskData)}</b></div>
              <div class="mt-5px">Do you want to continue?</div>`
            return info

            case "cleanup":
              var info = `You are about to execute a Clean Up 
                <br><div class="mt-5px">Job ID :<b> ${this.job.jobId}</b>
                <br>Vendor :<b> ${this.job.jobVendorId} - ${this.job.jobVendorName}</b></div>
                <div class="mt-5px">Do you want to continue?</div>`
              return info

            case "unschedule":
              var info = `You are about to Unschedule 
                <br><div class="mt-5px">Job ID :<b> ${this.job.jobId}</b>
                <br>Vendor :<b> ${this.job.jobVendorId} - ${this.job.jobVendorName}</b></div>
                <div class="mt-5px">Do you want to continue?</div>`
              return info

            case "requestproductionreports":
              var info = `You are about to Request Production Push Reports 
                <br><div class="mt-5px">Job ID :<b> ${this.job.jobId}</b>
                <br>Vendor :<b> ${this.job.jobVendorId} - ${this.job.jobVendorName}</b>
                <br>Task :<b> ${this.getTasksText(this.ppReportsData)}</b></div>
                <div class="mt-5px">Do you want to continue?</div>`
              return info
  
            case "requestreportingreports":
              var info = `You are about to Request Pre-processing Reports 
                <br><div class="mt-5px">Job ID :<b> ${this.job.jobId}</b>
                <br>Vendor :<b> ${this.job.jobVendorId} - ${this.job.jobVendorName}</b>
                <br>Task :<b> ${this.getTasksText(this.rReportsData)}</b></div>
                <div class="mt-5px">Do you want to continue?</div>`
              return info

            default:
              return "Do you want to continue?"
        }
      },

      getTasksText(taskList){
        var tasks = '';

        for(var task of Object.values(taskList)) {
          if(tasks != '') tasks = `${tasks}, `

          if(task.taskId != null && task.taskStatus != _constants.status.FINISHED){
            taskTypeText = _constants.GetTaskTypeString(task.taskType).replace(' Report','');
            tasks = `${tasks} ${taskTypeText}`
          }else{
            taskTypeText = _constants.GetTaskTypeString(task).replace(' Report','');
            tasks = `${tasks} ${taskTypeText}`
          }
        }

        return tasks
      }

    }
  });
};
