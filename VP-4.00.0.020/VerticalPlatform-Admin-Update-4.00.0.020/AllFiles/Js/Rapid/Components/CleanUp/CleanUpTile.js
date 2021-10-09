var cleanUpTileComponent = function () {
  let TileTemplate = `
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
            <div class="vp-col col-3 mr--20px p-0">
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
    </div>
  </div>
`;
  
  Vue.component('clean-up-tile', {
    template: TileTemplate,
    props: {
      jobProp: {
        required: true,
        type: _models.JobModel()
      }
    },
    data() {
      return {
        job: this.jobProp,
        expandReports: false,
        ppErrorCount: 0,
        reportingTask: new _models.TaskModel(), 
        reportingInsertTask:  {..._models.TaskModel(),
          taskName:'Insert',
          taskCount:0
        },
        reportingUpdateTask:  {..._models.TaskModel(),
          taskName:'Update',
          taskCount:0
        },
        reportingDeleteTask:  {..._models.TaskModel(),
          taskName:'Delete',
          taskCount:0
        },
        reportingErrorTask:  {..._models.TaskModel(),
          taskName:'Error',
          taskCount:0
        },
        reportingReEnablesTask:  {..._models.TaskModel(),
          taskName:'Re-enables <br/><br/>',
          taskCount: 0
        },
        reportingIgnoreInRapidTask:  {..._models.TaskModel(),
          taskName:'Ignored in Rapid <br/><br/>',
          taskCount: 0
        },
        reportingIgnoredSearchOptionsTask:  {..._models.TaskModel(),
          taskName:'Ignored Search Options',
          taskCount: 0
        },
        productionReportInsertTask:  {..._models.TaskModel(),
          taskName:'Insert',
          taskCount:0
        },
        productionReportUpdateTask:  {..._models.TaskModel(),
          taskName:'Update',
          taskCount:0
        },
        productionReportDeleteTask:  {..._models.TaskModel(),
          taskName:'Delete',
          taskCount:0
        },
        productionReportErrorTask:  {..._models.TaskModel(),
          taskName:'Error',
          taskCount:0
        }
      };
    },
    created: function () {
      this.filterTasks();
    },
    methods: {
      filterTasks(){
        this.job.jobTasks.forEach(task => {
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
            
            this.reportingTask = task;
          }

          if(task.taskType == _constants.taskType.INSERT){
            this.productionReportInsertTask.taskCount = task.taskInsertedRecords;
            this.ppErrorCount += task.taskErrorRecords;
          }
          if(task.taskType == _constants.taskType.UPDATE){
            this.productionReportUpdateTask.taskCount = task.taskUpdatedRecords;
            this.ppErrorCount += task.taskErrorRecords;
          }
          if(task.taskType == _constants.taskType.DELETE){
            this.productionReportDeleteTask.taskCount = task.taskDeletedRecords;
            this.ppErrorCount += task.taskErrorRecords;
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

          if(task.taskType == _constants.taskType.PRODUCTIONPUSH_INSERT_REPORT){
            this.productionReportInsertTask = this.updateTaskData(this.productionReportInsertTask,task);
          }
          if(task.taskType == _constants.taskType.PRODUCTIONPUSH_UPDATE_REPORT){
            this.productionReportUpdateTask = this.updateTaskData(this.productionReportUpdateTask,task);
          }
          if(task.taskType == _constants.taskType.PRODUCTIONPUSH_DELETE_REPORT){
            this.productionReportDeleteTask = this.updateTaskData(this.productionReportDeleteTask,task);
          }
          if(task.taskType == _constants.taskType.PRODUCTIONPUSH_ERROR_REPORT){
            this.productionReportErrorTask = this.updateTaskData(this.productionReportErrorTask,task);
          }
        });

        this.productionReportErrorTask = {...this.productionReportErrorTask,
          taskCount: this.ppErrorCount
        };

      },
      updateTaskData(taskData, task){
        return {...task,
          taskName: taskData.taskName,
          taskCount: taskData.taskCount
        }
      },
    }
  });
};
  