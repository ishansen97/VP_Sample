var completedJobDetailModal = function () {
  let modaltemplate = `
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="vp-rapid-modal-container">
          <div class="modal-header">
            <slot name="header">
              <label class="label-text">Job Statistics</label>
              <button type="button" value="" class="modal-default-button close-modal" @click="$emit(_constants.modalClose.completed)">&#10006;</button>
            </slot>
          </div>

          <div class="vp-section mb-0">
          <div class="card" >
            <div class="header">
              <div class="vp-row">
                <div class="vp-col col-4 truncate">
                  <b>Site: {{job.jobSiteName}}</b>
                </div>
                <div class="vp-col col-fill">
                  <b>Job ID: {{job.jobId}}</b>
                </div>
              </div>
            </div>
            <div class="body">
              <div class="vp-row">
                <div class="vp-col col-5">
                  <div><small class="tiny-label">Vendor:</div>
                  {{job.jobVendorId}} - {{job.jobVendorName}}
                </div>
                <div class="vp-col col-7">
                  <div><small class="tiny-label">Data File:</small></div>
                  <div v-bind:title="job.jobDataFileName">
                    {{job.jobDataFileName}}
                  </div>
                </div>
              </div>
              <div class="vp-row">
                <div class="vp-col col-6">
                  <div class="vp-row">
                    <div class="vp-col col-fill">
                      <div class="sub-header">Pre-processing</div>
                    </div>
                  </div>
                  <div class="vp-row pre-processing-report">
                    <div class="vp-col col-12">
                      <div class="vp-row m-0">
                      <completed-job-reporting-data :taskProp="reportingInsertTask"/>
                      <completed-job-reporting-data :taskProp="reportingUpdateTask"/>
                      <completed-job-reporting-data :taskProp="reportingDeleteTask"/>
                      <completed-job-reporting-data :taskProp="reportingErrorTask"/>
                      </div>
                    </div>
                  </div>
                  <div class="vp-row m-0 more-reports-header" @click="expandReports = !expandReports">
                    <div class="vp-col col-4 mr--15px p-0">
                      <div>
                        <div>
                          More Reports
                        </div>
                      </div>
                    </div>
                    <div class=" vp-col col-8 article_srh_btn report-search-btn" v-bind:class="{ hide_icon: expandReports }"/>
                  </div>
                  <div class="vp-row pre-processing-report">
                    <div class="vp-col col-12">
                      <div class="vp-row m-0 report-anim" v-bind:class="{ expand: expandReports }">
                        <completed-job-reporting-data :taskProp="reportingReEnablesTask"/>
                        <completed-job-reporting-data :taskProp="reportingIgnoredSearchOptionsTask"/>
                        <completed-job-reporting-data :taskProp="reportingIgnoreInRapidTask"/>
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
                      <completed-job-reporting-data :taskProp="productionReportInsertTask"/>
                      <completed-job-reporting-data :taskProp="productionReportUpdateTask"/>
                      <completed-job-reporting-data :taskProp="productionReportDeleteTask"/>
                      <completed-job-reporting-data :taskProp="productionReportErrorTask"/>
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
              
              <div class="vp-row">
                <div class="vp-col col-12">
                  <div v-if="showTimeBreakDown">
                    <div class="vp-row">
                      <div class="vp-col col-12">
                        <div class="sub-header">Execution Time Breakdown</div>
                      </div>
                    </div>
                    <div class="vp-custom-table">
                      <div class="vp-custom-table-row">
                        <div class="vp-custom-table-cell p-0 no-border">
                          <div class="vp-custom-table-row header p-0">
                            <div class="vp-custom-table-cell" style="width: 30%;">Task Name</div>
                            <div class="vp-custom-table-cell" style="width: 25%;">Start Time</div>
                            <div class="vp-custom-table-cell" style="width: 25%;">End Time</div>
                            <div class="vp-custom-table-cell" style="width: 20%;">Duration</div>
                          </div>
                          <div>
                            <completed-task-time-data :taskProp="reportingTask" v-if="reportingTask.taskType == _constants.taskType.REPORTS"/>
                            <completed-task-time-data :taskProp="productionPushInsert" v-if="productionPushInsert.taskType == _constants.taskType.INSERT && productionPushInsert.taskStatus == _constants.status.FINISHED"/>
                            <completed-task-time-data :taskProp="productionPushUpdate" v-if="productionPushUpdate.taskType == _constants.taskType.UPDATE && productionPushUpdate.taskStatus == _constants.status.FINISHED"/>
                            <completed-task-time-data :taskProp="productionPushDelete" v-if="productionPushDelete.taskType == _constants.taskType.DELETE && productionPushDelete.taskStatus == _constants.status.FINISHED"/>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          </div>
        </div>
      </div>
    </div>
  </transition>
  `;

  Vue.component("completed-job-detail-modal", {
    template: modaltemplate,
    props: {
      jobProp: {
        required: true,
        type: _models.JobModel()
      }
    },
    watch: {
      jobProp: {
        immediate: true,
        handler() {
          this.job = this.jobProp;
          this.filterTasks();
        }
      }
    },
    data() {
      return {
        job: _models.JobModel(),
        showTimeBreakDown: false,
        expandReports: false,
        reportingInsertTask: {
          ..._models.TaskModel(),
          taskName: 'Insert',
          taskCount: 0
        },
        reportingUpdateTask: {
          ..._models.TaskModel(),
          taskName: 'Update',
          taskCount: 0
        },
        reportingDeleteTask: {
          ..._models.TaskModel(),
          taskName: 'Delete',
          taskCount: 0
        },
        reportingErrorTask: {
          ..._models.TaskModel(),
          taskName: 'Error',
          taskCount: 0
        },
        reportingReEnablesTask:  {
          ..._models.TaskModel(),
          taskName:'Re-enables <br/><br/>',
          taskCount: 0
        },
        reportingIgnoreInRapidTask:  {
          ..._models.TaskModel(),
          taskName:'Ignored in Rapid',
          taskCount: 0
        },
        reportingIgnoredSearchOptionsTask:  {
          ..._models.TaskModel(),
          taskName:'Ignored Search Options',
          taskCount: 0
        },
        productionReportInsertTask: {
          ..._models.TaskModel(),
          taskName: 'Insert',
          taskCount: 0
        },
        productionReportUpdateTask: {
          ..._models.TaskModel(),
          taskName: 'Update',
          taskCount: 0
        },
        productionReportDeleteTask: {
          ..._models.TaskModel(),
          taskName: 'Delete',
          taskCount: 0
        },
        productionReportErrorTask: {
          ..._models.TaskModel(),
          taskName: 'Error',
          taskCount: 0
        },
        reportingTask: {
          ..._models.TaskModel(),
          taskName: 'Pre-Processing'
        },
        productionPushInsert: {
          ..._models.TaskModel(),
          taskName: 'Production Push - Insert'
        },
        productionPushUpdate: {
          ..._models.TaskModel(),
          taskName: 'Production Push - Update'
        },
        productionPushDelete: {
          ..._models.TaskModel(),
          taskName: 'Production Push - Delete'
        }
      };
    },
    methods: {
      filterTasks() {
        this.job.jobTasks.forEach(task => {
          if (task.taskType == _constants.taskType.REPORTING_INSERT_REPORT) {
            this.reportingInsertTask = {
              ...task,
              taskName: this.reportingInsertTask.taskName,
              taskCount: task.taskInsertedRecords
            };
          }
          if (task.taskType == _constants.taskType.REPORTING_UPDATE_REPORT) {
            this.reportingUpdateTask = {
              ...task,
              taskName: this.reportingUpdateTask.taskName,
              taskCount: task.taskUpdatedRecords
            };
          }
          if (task.taskType == _constants.taskType.REPORTING_DELETE_REPORT) {
            this.reportingDeleteTask = {
              ...task,
              taskName: this.reportingDeleteTask.taskName,
              taskCount: task.taskDeletedRecords
            };
          }
          if (task.taskType == _constants.taskType.REPORTING_ERROR_REPORT) {
            this.reportingErrorTask = {
              ...task,
              taskName: this.reportingErrorTask.taskName,
              taskCount: task.taskErrorRecords
            };
          }
          if(task.taskType == _constants.taskType.REPORTING_REENABLED_REPORT){
            this.reportingReEnablesTask = {
              ...task,
              taskName: this.reportingReEnablesTask.taskName,
              taskCount: task.taskReEnabledProductCount
            };
          }
          if(task.taskType == _constants.taskType.REPORTING_IGNOREDINRAPID_REPORT){
            this.reportingIgnoreInRapidTask = {
              ...task,
              taskName: this.reportingIgnoreInRapidTask.taskName,
              taskCount: task.taskIgnoredInRapidProductCount
            };
          }
          if(task.taskType == _constants.taskType.REPORTING_IGNOREDSEARCHOPTION_REPORT){
            this.reportingIgnoredSearchOptionsTask = {
              ...task,
              taskName: this.reportingIgnoredSearchOptionsTask.taskName,
              taskCount: task.taskIgnoredSearchOptionProductCount
            };
          }
          if (task.taskType == _constants.taskType.PRODUCTIONPUSH_INSERT_REPORT) {
            this.productionReportInsertTask = {
              ...task,
              taskName: this.productionReportInsertTask.taskName,
              taskCount: task.taskInsertedRecords
            };
          }
          if (task.taskType == _constants.taskType.PRODUCTIONPUSH_UPDATE_REPORT) {
            this.productionReportUpdateTask = {
              ...task,
              taskName: this.productionReportUpdateTask.taskName,
              taskCount: task.taskUpdatedRecords
            };
          }
          if (task.taskType == _constants.taskType.PRODUCTIONPUSH_DELETE_REPORT) {
            this.productionReportDeleteTask = {
              ...task,
              taskName: this.productionReportDeleteTask.taskName,
              taskCount: task.taskDeletedRecords
            };
          }
          if (task.taskType == _constants.taskType.PRODUCTIONPUSH_ERROR_REPORT) {
            this.productionReportErrorTask = {
              ...task,
              taskName: this.productionReportErrorTask.taskName,
              taskCount: task.taskErrorRecords
            };
          }

          if (task.taskType == _constants.taskType.REPORTS) {
            this.showTimeBreakDown = true;
            this.reportingTask = {
              ...task,
              taskName: this.reportingTask.taskName
            };
          }

          if (task.taskType == _constants.taskType.INSERT) {
            this.showTimeBreakDown = true;
            this.productionPushInsert = {
              ...task,
              taskName: this.productionPushInsert.taskName
            };
          }

          if (task.taskType == _constants.taskType.UPDATE) {
            this.showTimeBreakDown = true;
            this.productionPushUpdate = {
              ...task,
              taskName: this.productionPushUpdate.taskName
            };
          }

          if (task.taskType == _constants.taskType.DELETE) {
            this.showTimeBreakDown = true;
            this.productionPushDelete = {
              ...task,
              taskName: this.productionPushDelete.taskName
            };
          }
        });
      }
    }
  });
};



