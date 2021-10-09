var completedTabComponent = function () {
  let TabTemplate = `
<div>
  <completed-job-detail-modal :jobProp="job" v-if="jobDetailModal" @completedInfoClose="jobDetailModal = false"/>
  <div class="no-data-placeholder" v-if="initialJobsLength == 0">
    {{loadingMessage}}<spinner v-if="showSpinner"/>
  </div>

  <div class="vp-rapid-container" v-if="initialJobsLength > 0">
    <div class="article_srh_btn " v-bind:class="{ hide_icon: showSearch }" @click="showSearch = !showSearch">Search
    </div>
    <div class="article_srh_pane search-anim" v-bind:class="{ expand: showSearch }">
      <div class="inline-form-container">
        <div class="vp-row mb-3">
          <div class="vp-col col-2 text-right div-center">
            <label class="w-100">Site</label>
          </div>
          <div class="vp-col col-fill">
            <drop-down-list 
              :listProp="sites" 
              :placeholderProp="sitesPlaceHolder"
              :resetProp="site.siteId? false : true"
              :selectFunc="siteSelected" 
              :resetFunc="siteReset" />
          </div>
        </div>
        <div class="vp-row mb-3">
          <div class="vp-col col-2 text-right div-center">
            <label class="w-100">Vendor</label>
          </div>
          <div class="vp-col col-fill">
            <drop-down-list 
            :listProp="vendors" 
            :disabled="isVendorDisabled" 
            :placeholderProp="vendorsPlaceHolder"
            :resetProp="vendor.vendorId? false : true"
            :showIdProp="true"
            :selectFunc="vendorSelected" 
            :resetFunc="vendorReset" />
          </div>
        </div>
        <div class="vp-row mb-3">
          <div class="vp-col col-2 text-right div-center">
            <label class="w-100">Created Date</label>
          </div>
          <div class="vp-col col-fill">
            <div class="input-prepend">
              <span class="add-on">From</span>
              <input type="text"  class="w-120px"  id="fromDatepicker" v-model="fromDate">
            </div>
            <div class="input-prepend">
              <span class="add-on">To</span>
              <input type="text" class="w-120px" id="toDatepicker" v-model="toDate">
            </div>
          </div>
        </div>
        <div class="form-actions vp-row mb-3 mt-3">
          <div class="vp-col col-2"></div>
          <div class="vp-col col-fill">
              <button type="button" 
                @click="filter()" 
                title="Filter completed jobs" 
                class="waves-effect waves-light btn">
                Apply
              </button>
              <button type="button" 
                @click="clearFilter()" 
                title="Clear Search Filter" 
                class="waves-effect waves-light btn">
                Reset Filter
              </button>
          </div>
        </div>
      </div>
    </div>
    <div class="no-data-placeholder" v-if="showFilterDataSpinner">
      <spinner v-if="showFilterDataSpinner"/>
    </div>
    <div v-if="completedJobs.length > 0 && !showFilterDataSpinner">
      <div class="vp-custom-table">
        <div class="vp-custom-table-row">
          <!-- add class .error or .active to get specific state change -->
          <div class="vp-custom-table-cell p-0 no-border">
            <div class="vp-custom-table-row header">
              <div class="vp-custom-table-cell header-background" style="width: 8%;">Job Id</div>
              <div class="vp-custom-table-cell header-background" style="width: 28%;">Vendor</div>
              <div class="vp-custom-table-cell header-background" style="width: 20%;">Created Date Time</div>
              <div class="vp-custom-table-cell header-background" style="width: 20%;">End Date Time</div>
              <div class="vp-custom-table-cell header-background" style="width: 15%;">Duration</div>
              <div class="vp-custom-table-cell header-background" style="width: 8%;"></div>
            </div>
            <div class="vp-custom-table-row " v-for="job in completedJobs" >
              <div class="vp-custom-table-cell align-vertical" style="width: 8%;">{{job.jobId}}</div>
              <div class="vp-custom-table-cell align-vertical break-on-word" style="width: 28%;">{{job.jobVendorId}} - {{job.jobVendorName}}</div>
              <div class="vp-custom-table-cell align-vertical" style="width: 20%;">{{job.jobCreatedOn}}</div>
              <div class="vp-custom-table-cell align-vertical" style="width: 20%;">{{job.jobEndTime}}</div>
              <div class="vp-custom-table-cell align-vertical" style="width: 15%;">{{job.jobTotalDuration}}</div>
              <div class="vp-custom-table-cell align-vertical" style="width: 8%;">
                <button v-if="job.jobStatus == _constants.status.FINISHED" 
                  type="button" 
                  @click="viewDetail(job)" 
                  title="View job detail information" 
                  class="w-100 waves-effect waves-light btn">
                Show
                </button>
                <div  v-if="job.jobStatus == _constants.status.CANCELED">Canceled</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <page-list 
      :totalCountProp="_apiDataStore.completedJobsPagination.totalCount" 
      :pageLimitProp="_constants.pageLimit"
      :paginateFunc="paginate"
      :resetProp="resetPagination"
      :resetCompleteCallBack="paginationResetComplete"/>
    </div>
    <div v-if="completedJobs.length == 0" class="no-data-placeholder">
      No Records Found
    </div>
  </div>
</div>
`;

  Vue.component('completed-tab', {
    template: TabTemplate,
    mixins: [_jobApiMixin, _taskApiMixin],
    data() {
      return {
        jobDetailModal: false,
        job:{},
        resetPagination: false,
        initialJobsLength: 0,
        showSpinner: false,

        showSearch: false,
        searchRenderComplete: false,
        sitesPlaceHolder: 'Loading Sites...',
        vendorsPlaceHolder: 'Select a Site first',
        site: {},
        vendor: {},
        isVendorDisabled: true,
        fromDate: '',
        toDate: '',
        showFilterDataSpinner: false
      };
    },
    created: async function () {
      this.showSpinner = true;
      this.loadingMessage = "";
      await this.GetCompletedJobs();
      this.initialJobsLength = this.completedJobs.length;
      this.GetSites();
    },
    watch: {
      sites(){
        if(this.sites.length > 0){
          this.sitesPlaceHolder = ` `
        }
      },
      async site(){
        this.vendor = {};
        this.vendorsPlaceHolder = "Select a Site first";
        this.isVendorDisabled = true;

        if(this.site.siteId){
          this.vendorsPlaceHolder = "Loading vendors...";
          await this.GetVendorsBySite(this.site.siteId);
          this.vendorsPlaceHolder = ` `
          this.isVendorDisabled = false;
        }
      },
      completedJobs() {
        if (_apiDataStore.completedJobs.length === 0) {
          this.loadingMessage = "No Jobs in Completed State";
          this.showSpinner = false;
        }
      },
      showSearch(){
        if(!this.showSearch){
          this.searchRenderComplete = false
        }
      }
    },
    computed:{
      completedJobs(){
        return _apiDataStore.completedJobs;
      }
    },
    updated() {
      this.$nextTick(function () {
        if(document.getElementById("fromDatepicker") && !this.searchRenderComplete){
          var self =  this
          $('#fromDatepicker').datepicker({
            changeYear: true,
            maxDate: '0',
            onSelect:function(selectedDate, datePicker) {            
                self.fromDate = selectedDate;
            }
          });

          $('#toDatepicker').datepicker({
            changeYear: true,
            maxDate: '0',
            onSelect:function(selectedDate, datePicker) {            
                self.toDate = selectedDate;
            }
          });

          this.searchRenderComplete = true;
        }
      })
    },
    methods: {
      async viewDetail(val) {
        this.job = val;
        this.job.jobTasks = await this.GetTasksByJobId(val.jobId);
        this.jobDetailModal = true;
      },

      async paginate(start, end){
        _apiDataStore.completedJobsPagination.startIndex = start;
        _apiDataStore.completedJobsPagination.endIndex = end;
        await this.GetCompletedJobs();
      },

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

      async filter(){
        _apiDataStore.completedJobsFilterData = {};
        if(this.site.siteId){
          _apiDataStore.completedJobsFilterData[_constants.filterKeys.siteId] =
           this.site.siteId
        }
        if(this.vendor.vendorId){
          _apiDataStore.completedJobsFilterData[_constants.filterKeys.vendorId] =
           this.vendor.vendorId
        }
        if(this.toDate != ''){
          _apiDataStore.completedJobsFilterData[_constants.filterKeys.toDate] =
           this.toDate
        }
        if(this.fromDate != ''){
          _apiDataStore.completedJobsFilterData[_constants.filterKeys.fromDate] =
           this.fromDate
        }
        if(this.toDate != '' && this.fromDate != '' && this.fromDate > this.toDate){
          $.notify({ message: 'To date must be greater than from date', type: 'info' });
        }

        this.showFilterDataSpinner = true;
        this.resetPagination = true;
        _apiDataStore.completedJobsPagination = new _models.PaginationModel();

        await this.GetCompletedJobs();
        this.showFilterDataSpinner = false;
      },

      paginationResetComplete(){
        if (this.resetPagination){
          this.resetPagination = false
        }
      },

      async clearFilter(){
        this.siteReset();
        this.fromDate = '';
        this.toDate = '';

        this.showFilterDataSpinner = true;
        this.resetPagination = true;
        _apiDataStore.completedJobsPagination = new _models.PaginationModel();
        _apiDataStore.completedJobsFilterData = {};
        await this.GetCompletedJobs();
        this.showFilterDataSpinner = false;
      }
    }
  });
};
