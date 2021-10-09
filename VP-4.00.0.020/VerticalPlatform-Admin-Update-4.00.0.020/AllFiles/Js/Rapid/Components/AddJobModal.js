var addJobModal = function(){
  let modaltemplate = `
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper">
        <div class="modal-container add-job-modal-container">

          <div class="modal-header">
            <slot name="header">
              <h3>Add Rapid Job</h3>
            </slot>
          </div>

          <div class="modal-body add-job-modal-body">
            <slot name="body">
              <div class="vp-row mb-3">
                <div class="vp-col col-3 div-center">
                  <label>Site</label>
                </div>
                <div class="vp-col col-fill">
                  <drop-down-list 
                    :disabled="isSiteDisabled" 
                    :listProp="sites" 
                    :placeholderProp="sitesPlaceHolder"
                    :defaultSelectIdProp="CONFIG.currentSite"
                    :selectFunc="siteSelected" 
                    :resetFunc="siteReset" />
                </div>
              </div>
              <div class="vp-row mb-3">
                <div class="vp-col col-3 div-center">
                  <label>Vendor</label>
                </div>
                <div class="vp-col col-fill">
                  <drop-down-list 
                  :disabled="isActionDisabled" 
                  :listProp="vendors" 
                  :placeholderProp="vendorsPlaceHolder"
                  :resetProp="vendor.vendorId? false : true"
                  :showIdProp="true"
                  :selectFunc="vendorSelected" 
                  :resetFunc="vendorReset" />
                </div>
              </div>
              <div class="vp-row mb-3">
                <div class="vp-col col-3">
                  <label>Emails</label> 
                </div>
                <div class="vp-col col-fill">
                  <textarea :disabled='isDataDisabled' v-model="job.jobEmails" @blur="validateEmails"></textarea>
                  <div class="vp-row">
                    <div class="vp-col col-12">
                      <label class="form-message error" v-if="emailError.status">{{emailError.message}}</label>
                    </div>
                  </div>
                </div>
              </div>
              <div class="vp-row mb-3">
                <div class="vp-col col-3 div-center">
                  <label>Rule File</label>
                </div>
                <div class="vp-col col-fill">
                  <input type="file" id="rulefileinput" accept=".csv" :disabled='isDataDisabled' @change="selectRuleFile($event.target.files)">
                  <div class="vp-row">
                    <div class="vp-col col-12">
                      <label class="form-message info" v-if="vendorStatus.vendorIsVendorOk">{{vendorStatus.vendorMessage}}</label>
                    </div>
                  </div>
                </div>
              </div>
              <div class="vp-row mb-3">
                <div class="vp-col col-3 div-center">
                  <label>Data File</label>
                </div>
                <div class="vp-col col-fill">
                  <input type="file" id="datafileinput" accept=".csv,.tab" :disabled='isDataUploadOnly? false : isDataDisabled' @change="selectDataFile($event.target.files)">
                </div>
              </div>
            </slot>
            <div class="vp-row">
              <div class="vp-col col-fill">
                <label class="form-message error" v-if="!(vendorStatus.vendorIsVendorOk)">{{vendorStatus.vendorMessage}}</label>
                <label class="form-message " :class="{ 'success': !(uploadDetails?.retry), 'error': (uploadDetails?.retry)  }">
                {{notificationMessage}}
                <a v-if="this.uploadDetails?.retry && retryCount<retryLimit && retryEnabled" @click="reUploadDataFile(); "> click here to reupload</a> 
                </label>
              </div>
            </div>
          </div>
          
          <div class="modal-footer">
            <slot name="footer">
            <input type="button" value="Create" class="modal-default-button btn" :disabled='isDataAdded' @click="create(); ">
            <input type="button" value="Cancel" class="modal-default-button btn mr-3" :disabled='isCloseDisabled' @click="Close()">
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
  `;

  Vue.component("add-job-modal", {
    template: modaltemplate,
    mixins: [_jobApiMixin],
    data() {
      return {
        vendors:[],
        sitesPlaceHolder: 'Loading Sites...',
        vendorsPlaceHolder: '',
        site: {},
        vendor: {},
        vendorResetParent:false,
        job: {..._models.JobModel(),
          jobEmails: CONFIG.currentUserEmail
        },
        vendorStatus: new _models.VendorStatusModel(),
        ruleFile: {},
        dataFile: {},
        isDataDisabled: true,
        isDataUploadOnly: false,
        isActionDisabled: false,
        isCloseDisabled: false,
        emailError:  {
          status : false,
          message: ''
        },
        retryEnabled: false,
        retryLimit:3,
        retryCount:0,
        notificationMessage: "",
        jobSuccessAlertMessage: "Job created successfully",
        uploadFailedAlertMessage: "Upload failed"
      };
    },
    created: function () {
      this.GetSites();
    },
    watch: {
      sites(){
        if(this.sites.length > 0){
          this.sitesPlaceHolder = `Sites search; No of Sites: ${this.sites.length} `
        }
      },
      async site(){
        this.vendor = {};
        this.vendorStatus = new  _models.VendorStatusModel();
        this.isActionDisabled = true;
        this.isDataDisabled = true;
        this.vendorsPlaceHolder = "";

        if(this.site.siteId){
          this.vendorsPlaceHolder = "Loading vendors...";
          await this.GetVendorsBySite(this.site.siteId);
          this.vendorsPlaceHolder = `Vendor search; No of Vendors: ${this.vendors.length} `
          this.isActionDisabled = false;
        }
      },
      async vendor(){
        document.querySelector('#rulefileinput').value = '';
        
        if (this.vendor.vendorId){
          this.isDataDisabled = true;
          this.vendorStatus = await this.VendorStatus(this.vendor.vendorId);
          this.validateEmails();
          if(this.vendorStatus.vendorIsVendorOk){
            this.isDataDisabled = false;
          }
        }else {
          this.isDataDisabled = true;
          this.vendorStatus = new _models.VendorStatusModel(),
          this.emailError = {
            status: false,
            message: ''
          };
        }
      },
      async uploadDetails(){
        this.notificationMessage = this.uploadDetails.message;

        if(this.uploadDetails?.success){
          this.job.jobDataFilePath = this.uploadDetails.filePath;
          this.job.jobStatus = _constants.status.QUEUE;
          await this.UpdateJob(this.job);
          await this.GetReportJobsAndTasks();
          $.notify({ message: this.jobSuccessAlertMessage, type: 'ok' });
          this.$emit(_constants.modalClose.addJob);
        }
        else if(this.uploadDetails?.retry){
          this.retryEnabled = false;
          this.isCloseDisabled = false;
          this.isDataUploadOnly = true;

          this.notificationMessage = `${this.uploadDetails.message} Reselect Data File.  `;
          $.notify({ message: this.uploadFailedAlertMessage, type: 'error' });
          document.querySelector('#datafileinput').value = '';
        }
      }
    },
    computed: {
    	isDataAdded: function(){
       return  !(this.dataFile.size > 0) ||
       !(this.vendorStatus.vendorRuleFileStatus) ||
       this.isActionDisabled ||
       this.emailError.status;
      },
      isDataUploadDisabled: function(){
        if(isDataUploadOnly){
          return true;
        }
      },
      isSiteDisabled: function(){
        if(!this.site.siteId || !this.vendorStatus.vendorIsVendorOk){
          return false;
        }
        return this.isDataDisabled;
      }
    },
    methods: {
      async vendorSelected(data){
        this.vendor = data;
      },

      vendorReset(){
        this.vendor = {};
      },

      async siteSelected(data){
        this.site = data;
      },

      siteReset(){
        this.site = {};
      },

      selectDataFile (files) {
        this.dataFile = {};
        var file = files[0];
        var reg = /([a-zA-Z0-9!@#\$%\^\&*\)\(\[\]+=;,'`~._-\s]+)/g
        var type = file?.name.split(".").pop();
        var invalidChars = file?.name.replace(reg, '');

        if(type != 'csv' && type != 'tab'){
          alert( "Please select CSV or TAB file type", "error");
          document.querySelector('#datafileinput').value = '';
        }else if( invalidChars.length > 0){
          alert( `File name contains the following invalid characters ${invalidChars}`,
           "error");
          document.querySelector('#datafileinput').value = '';
        }else{
          this.dataFile = file;
          this.retryEnabled = true;
        }
      },

      async selectRuleFile(files) {
        var file = files[0];

        if(file?.name.split(".").pop()!= 'csv'){
          alert( "Please select CSV file type", "error");
          document.querySelector('#rulefileinput').value = '';
        }else{
          this.ruleFile = file;
          if(file?.size > 0){
            this.vendorStatus.vendorRuleFileStatus = true;
          }else{
            this.vendorStatus = await this.VendorStatus(this.vendor.vendorId);
          }
        }
      },

      async create() {
        this.disabledAll(true);
        this.job.jobSiteId = this.site.siteId;
        this.job.jobVendorId = this.vendor.vendorId;
        if(this.ruleFile?.size > 0){
          this.vendorStatus.vendorMessage = "Uploading Rule File...";
          await this.UploadRuleFile(this.ruleFile, this.vendor.vendorId);
        }

        this.job = await this.AddJob(this.job);
        this.job.jobDataFileName = this.dataFile ? this.dataFile.name : '';
        this.retryCount = 0;
        await this.UploadDataFile(this.job, this.dataFile);
      },

      async reUploadDataFile(){
        this.notificationMessage = "";
        this.retryEnabled = true;
        this.retryCount++;
        await this.UploadDataFile(this.job, this.dataFile);
      },

      disabledAll(bool) {
        this.isActionDisabled = bool;
        this.isCloseDisabled = bool;
        this.isDataDisabled = bool;
      },

      validateEmails() {
        var string = this.job.jobEmails.replace(/\r?\n|\r|\s/g,'');
        this.job.jobEmails = string;
        if(string == '') {
          this.emailError = {
            status : true,
            message: 'Required.'
          };
          return;
        };

        var regex = /^\s*([\w-\.]+@([\w-]+\.)+[\w-]{2,4})\s*?$/;
        var result = string.split(/,|;/);
        var existing = [];
        var error = false;
        result.forEach(email => {
          var lowerEmail = email.toLowerCase();
          existing.forEach(exEmail => {
            if(email && exEmail.lastIndexOf(lowerEmail, 0) === 0){
              error = `Duplicate Found`;
            }
          });
          if(email && !regex.test(email)) {
            error = "Invalid format. use , or ; to separate ";
          }
          if(lowerEmail){
            existing.push(lowerEmail);
          }
        });
        
        if(existing.length > 20){
          this.emailError = {
            status : true,
            message: "Maximum 20 emails"
          };
          return;
        }

        if(error != false){
          this.emailError = {
            status : true,
            message: error
          };
          return;
        }

        this.emailError.status = false;
      },

      async Close(){
        if(this.job.jobId > 0){
          await this.CancelJobAndTasks(this.job.jobId);
        }
        await this.GetReportJobsAndTasks();
        this.$emit(_constants.modalClose.addJob);
      }

    }
  });
};