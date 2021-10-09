var reportsTileComponent = function () {
  let tileTemplate = `
    <div class="card">
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
            <div><small class="tiny-label">Vendor:</small></div>
            {{job.jobVendorId}} - {{job.jobVendorName}}
          </div>
          <div class="vp-col col-4">
            <div><small class="tiny-label">Data File:</small></div>
            <div class="truncate" v-bind:title="job.jobDataFileName">
              {{job.jobDataFileName}}
            </div>
          </div>
          <div class="vp-col col-2">
            <div><small class="tiny-label">Date:</small></div>
            {{getDate}}
          </div>
          <div class="vp-col col-fill">
            <div><small class="tiny-label">Time:</small></div>
            {{getTime}}
          </div>
        </div>
        <div class="vp-row mt-3">
          <div v-if="job.jobIsError" class="vp-col col-fill">
            <div class="mb-0" class="alert"> <!-- alert-success alert-danger -->
              {{job.jobErrorMessage}}
            </div>
          </div>
          <div v-else class="vp-col col-fill">
            <div class="mb-0" v-bind:class="{ alert: job.jobIsWarning }"> <!-- alert-success alert-danger -->
              {{job.jobWarningMessage}}
            </div>
          </div>
        </div>
        <div class="vp-row mt-3">
          <div class="vp-col col-auto" 
          v-if="_componentsDataStore.permission(_constants.permissions.EDIT) 
          || _componentsDataStore.permission(_constants.permissions.DELETE)">
            <label class="styled-file-input btn" 
            v-if="_componentsDataStore.permission(_constants.permissions.EDIT)"
            title="Update rule file for job and vendor" 
            :disabled="disableUpload" 
            :for="'rulesFile'+job.jobId">
              Upload Rule File
              <input type="file" 
              value ="Upload Rule File" 
              :disabled="disableUpload"
              :name="'rulesFile'+job.jobId"
              accept=".csv" 
              :id="'rulesFile'+job.jobId" 
              @change="rulesFileUpload($event.target.files)">
            </label>
            <input 
              type="button" 
              v-if="_componentsDataStore.permission(_constants.permissions.ADD) &&
              this.job.jobStatus == _constants.status.PENDING"
              title="Schedule the job" 
              @click="showConfirmModal(confirmModalText('schedule'),schedule)" 
              class="waves-effect waves-light btn" 
              value ="Schedule" />
            <input 
              type="button" 
              v-if="_componentsDataStore.permission(_constants.permissions.ADD) &&
              this.job.jobStatus != _constants.status.PENDING"
              :disabled="(job.jobStatus == _constants.status.INPROGRESS) || job.jobIsError" 
              title="Unschedule the job" 
              @click="showConfirmModal(confirmModalText('unschedule'),unschedule)" 
              class="waves-effect waves-light btn" 
              value ="Unschedule" />
            <input 
              type="button" 
              v-if="_componentsDataStore.permission(_constants.permissions.DELETE)"
              :disabled="(job.jobStatus == _constants.status.INPROGRESS)" 
              title="Cancel/End job and move to completed" 
              @click="showConfirmModal(confirmModalText('endjob'),endJob)" 
              class="waves-effect waves-light btn" 
              value ="End Job" />
          </div>
        </div>
      </div>
    </div>
`;

  Vue.component('reports-tile', {
    template: tileTemplate,
    mixins: [_jobApiMixin, _taskApiMixin, _sharedModalMixin],
    data() {
      return {
        job: new _models.JobModel()
      };
    },
    props: {
      jobProp: {
        required: true,
        type: _models.JobModel()
      },
      getNextQueueNumFunc: {
        type: Function
      }
    },
    computed: {
      getDate(){
        var dateTime = this.job.jobCreatedOn;
        return dateTime.substr(0, dateTime.indexOf(' '));
      },
      getTime(){
        var dateTime = this.job.jobCreatedOn;
        return dateTime.substr(dateTime.indexOf(' ') + 1);
      },
      disableUpload(){
        return this.job.jobStatus == _constants.status.QUEUE ||
         this.job.jobStatus == _constants.status.INPROGRESS ||
         !this.job.jobIsError
      }
    },
    watch: {
      jobProp: {
        immediate: true,
        handler() {
          this.job = this.jobProp;
        }
      }
    },
    methods: {
      async rulesFileUpload(files){
        var file = files[0];

        if(file.name.split(".").pop()!= 'csv'){
          alert( "Please select CSV file type", "error");
          document.querySelector('#rulesFile'+job.jobId).value = '';
          return;
        }
        await this.UploadRuleFile(file, this.job.jobVendorId);

        await this.ReQueueReports(this.job.jobId);
        await this.GetReportJobsAndTasks();
      },

      async endJob(){
        await this.CancelJobAndTasks(this.job.jobId);

        await this.GetReportJobsAndTasks();
        await this.GetCompletedJobs();
      },

      async schedule(){
        var queueNext = this.getNextQueueNumFunc();
        if(queueNext > 0){
          this.job.jobOrder = queueNext;
          await this.UpdateJobOrder(this.job);
        }

        for (var task of this.job.jobTasks) {
          task.taskStatus = _constants.status.QUEUE;
          await this.UpdateTaskStatus(task); 
        }
        var updatedJob = {...this.job}

        updatedJob.jobStatus = _constants.status.QUEUE;
        await this.UpdateJobStatus(updatedJob);
        await this.GetReportJobsAndTasks();
      },

      async unschedule(){
        try {
          await this.UnscheduleJobAndTasks(this.job.jobId);
        } 
        finally {
          await this.GetReportJobsAndTasks();
        }
      },

      confirmModalText(action){
        switch (action) {
          case 'endjob':
            var info = `You are about to Cancel/End a Job 
                <br><div class="mt-5px">Job ID :<b> ${this.job.jobId}</b>
                <br>Vendor :<b> ${this.job.jobVendorId} - ${this.job.jobVendorName}</b></div>
                <div class="mt-5px">Do you want to continue?</div>`
            return info
          case 'schedule':
            var info = `You are about to schedule a job  
                <br><div class="mt-5px">Job ID :<b> ${this.job.jobId}</b>
                <br>Vendor :<b> ${this.job.jobVendorId} - ${this.job.jobVendorName}</b></div>
                <div class="mt-5px">Do you want to continue?</div>`
            return info
          case 'unschedule':
            var info = `You are about to unschedule a job  
                <br><div class="mt-5px">Job ID :<b> ${this.job.jobId}</b>
                <br>Vendor :<b> ${this.job.jobVendorId} - ${this.job.jobVendorName}</b></div>
                <div class="mt-5px">Do you want to continue?</div>`
            return info
        
          default:
            return "Do you want to continue?"
        }
      }
    }
  });
};
